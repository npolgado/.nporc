const { execSync } = require('child_process');

let data = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', c => data += c);
process.stdin.on('end', () => {
  try {
    const j = JSON.parse(data);
    const cwd = j.workspace?.current_dir || '';
    const model = j.model?.display_name || '';
    const ctx = j.context_window?.used_percentage;
    const rate = j.rate_limits?.five_hour?.used_percentage;

    let branch = 'n/a';
    try {
      branch = execSync('git --no-optional-locks rev-parse --abbrev-ref HEAD', {
        cwd: cwd || undefined, encoding: 'utf8', stdio: ['pipe','pipe','pipe']
      }).trim();
    } catch {}

    let out = `${cwd} | ${branch} | ${model}`;
    if (ctx != null) out += ` | ctx:${Math.round(ctx)}%`;
    if (rate != null) out += ` | 5h:${Math.round(rate)}%`;
    console.log(out);
  } catch {}
});
