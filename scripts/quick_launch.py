import os
import subprocess
import sys

import yaml

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button


class LaunchApp(App):
    def build(self):
        # read the lists of applications from a YAML file
        with open(os.path.join(os.getcwd(), "config/quick_launch.yaml"), "r") as f:
            app_data = yaml.safe_load(f)

        # create a vertical box layout for the buttons
        layout = BoxLayout(orientation="vertical")

        # create a button for each list of applications
        for list_name in app_data.keys():
            button = Button(text=list_name)
            button.bind(on_press=lambda instance, list_name=list_name: self.launch_app(list_name))
            layout.add_widget(button)

        return layout

    def launch_app(self, list_name):
        # get the selected list of applications
        with open(os.path.join(os.getcwd(), "config/quick_launch.yaml"), "r") as f:
            app_data = yaml.safe_load(f)
        if list_name in app_data:
            applications = app_data[list_name]

            # launch each application
            for app in applications:
                subprocess.Popen(app)
        else:
            print(f"List '{list_name}' not found.")

        sys.exit(1)

if __name__ == "__main__":
    LaunchApp().run()
