#!/usr/bin/env bash
input=$(cat)

# Use node to parse JSON (jq not available on this machine)
eval $(echo "$input" | node -e "
  const d=require('fs').readFileSync('/dev/stdin','utf8');
  try {
    const j=JSON.parse(d);
    const cwd=j.workspace?.current_dir||'';
    const model=j.model?.display_name||'';
    const ctx=j.context_window?.used_percentage;
    const rate=j.rate_limits?.five_hour?.used_percentage;
    console.log('cwd='+JSON.stringify(cwd));
    console.log('model='+JSON.stringify(model));
    console.log('ctx='+(ctx!=null?Math.round(ctx):''));
    console.log('rate='+(rate!=null?Math.round(rate):''));
  } catch(e) {}
")

branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null || echo "n/a")

out="$cwd | $branch | $model"
[ -n "$ctx" ] && out="$out | ctx:${ctx}%"
[ -n "$rate" ] && out="$out | 5h:${rate}%"
echo "$out"
