import os
import subprocess
import threading
from kivy.app import App
from kivy.core.window import Window
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.uix.popup import Popup



class MainSection(GridLayout):
    def __init__(self, **kwargs):
        super(MainSection, self).__init__(**kwargs)
        self.cols = 2
        self.padding = 20
        self.spacing = 20
        self.scripts_dir = "scripts"
        scripts = [f for f in os.listdir(os.path.join(os.getcwd(), self.scripts_dir)) if os.path.isfile(os.path.join(self.scripts_dir, f))]
        for script in scripts:
            button = Button(text=script)
            button.bind(on_press=self.launch_script)
            self.add_widget(button)

    def launch_script(self, instance):
        print(dir(App.get_running_app().log(f"Launching {instance.text}"))) # .root_window.ids.footer.text = f"Launching script: {instance.text}"
        path = os.path.join(os.path.join(os.getcwd(), "scripts"), instance.text)
        print(path)
        try:
            thread = threading.Thread(target=lambda: subprocess.run(["python", path]))
            thread.start()
            return
        except Exception as e:
            print(f"error running script!\n{e}")

class Header(BoxLayout):
    def __init__(self, **kwargs):
        super(Header, self).__init__(**kwargs)
        self.size_hint = (1, 0.2)
        self.orientation = "horizontal"
        self.spacing = 10

        self.title_label = Label(text="Launcher", font_size="24sp", size_hint=(1, 1), halign="center", valign="center")
        self.close_button = Button(text="Close", size_hint=(None, 1))
        self.close_button.bind(on_press=self.close_app)
        self.settings_button = Button(text="Settings", size_hint=(None, 1))
        self.settings_button.bind(on_press=self.show_settings)

        self.add_widget(self.title_label)
        self.add_widget(self.settings_button)
        self.add_widget(self.close_button)

    def close_app(self, instance):
        App.get_running_app().stop()

    def show_settings(self, instance):
        settings_popup = Popup(title="Settings", size_hint=(0.8, 0.8))
        ## ask for settings popup
        settings_popup.open()

class Footer(Label):
    def __init__(self, **kwargs):
        super(Footer, self).__init__(**kwargs)
        self.text = "Launcher Ready!"
        self.size_hint = (1, 0.2)
        # self.halign = 'left'
        # self.text_size = self.size
        # self.size_hint_x = None  # unset the size hint in the x direction

class LauncherApp(App):
    def build(self):
        Window.size = (1280, 720)
        self.layout = BoxLayout(orientation="vertical")
        self.header = Header()
        self.main = MainSection()
        self.footer = Footer()
        self.layout.add_widget(self.header)
        self.layout.add_widget(self.main)
        self.layout.add_widget(self.footer)
        return self.layout
    
    def log(self, text):
        self.footer.text = text

if __name__ == "__main__":
    os.system('read -p ""')
    from kivy.config import Config
    # Config.set('desktop', '1')
    # Config.set('exit_on_escape', '1')
    # Config.set('keyboard_mode', '1')
    # Config.set('kivy_clock', 'interrupt')
    # Config.set('log_enable', '1')
    # Config.set('log_level', 'critical')
    Config.set('graphics', 'maxfps', '10')
    Config.set('graphics', 'resizable', '1')
    Config.set('graphics', 'minimum_width', '300')
    Config.set('graphics', 'minimum_height', '400')
    Config.set('graphics', 'vsync', '1')
    LauncherApp().run()
