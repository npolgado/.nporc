#!/usr/bin/env python3

# KIVY BASE TEMPLATE
import kivy
from kivy.app import App
from kivy.clock import Clock
from kivy.config import Config

Config.set('graphics', 'width', '800')
Config.set('graphics', 'height', '600')
Config.set('graphics', 'minimum_width', '300')
Config.set('graphics', 'minimum_height', '400')
Config.set('graphics', 'resizable', True)
Config.set('graphics', 'vsync', '1')

Config.set('kivy', 'exit_on_escape', '1')
Config.set('kivy', 'log_level', 'debug')
Config.set('kivy', 'kivy_clock', 'interrupt')

from kivy.animation import Animation
from kivy.config import ConfigParser
from kivy.core.text import FontContextManager as FCM
from kivy.core.text import Label as CoreLabel
from kivy.core.text import LabelBase
from kivy.core.window import Window
from kivy.graphics import *
from kivy.graphics import Color, Ellipse, Line, Rectangle
from kivy.graphics.svg import Svg
from kivy.graphics.texture import Texture
from kivy.lang import Builder
from kivy.properties import (BooleanProperty, ListProperty, NumericProperty,
                             ObjectProperty, ReferenceListProperty,
                             StringProperty)
from kivy.uix.anchorlayout import AnchorLayout
from kivy.uix.behaviors import ButtonBehavior, FocusBehavior
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button, Buttons
from kivy.uix.checkbox import CheckBox
from kivy.uix.dropdown import DropDown
from kivy.uix.filechooser import (FileChooser, FileChooserController,
                                  FileChooserIconLayout, FileChooserIconView,
                                  FileChooserListLayout, FileChooserListView)
from kivy.uix.floatlayout import FloatLayout
from kivy.uix.gridlayout import GridLayout
from kivy.uix.image import Image
from kivy.uix.label import Label
from kivy.uix.pagelayout import PageLayout
from kivy.uix.popup import Popup
from kivy.uix.progressbar import ProgressBar
from kivy.uix.recycleboxlayout import RecycleBoxLayout
from kivy.uix.recycleview import RecycleView
from kivy.uix.recycleview.layout import LayoutSelectionBehavior
from kivy.uix.recycleview.views import RecycleDataViewBehavior
from kivy.uix.relativelayout import RelativeLayout
from kivy.uix.screenmanager import (FadeTransition, FallOutTransition,
                                    RiseInTransition, Screen, ScreenManager,
                                    SlideTransition, SwapTransition,
                                    WipeTransition)
from kivy.uix.scrollview import ScrollView
from kivy.uix.settings import SettingsWithSidebar
from kivy.uix.slider import Slider
from kivy.uix.spinner import Spinner
from kivy.uix.stacklayout import StackLayout
from kivy.uix.textinput import TextInput
from kivy.uix.togglebutton import ToggleButton
from kivy.uix.widget import Widget

# Recycle Box layout for selecting initialization zone
Builder.load_string('''
<ZoneViewer>:
    viewclass: 'Button' 
    orientation: "vertical"
    spacing: 0
    padding:10, 0
    space_x: self.size[0]/3
  
    RecycleBoxLayout:
        #color:(0, 0.7, 0.4, 0.8)
        default_size: None, dp(56)
        default_size_hint: 1, None 
        size_hint_y: None
        height: self.minimum_height
        orientation: 'vertical' 
        spacing: 15
''')
                    
# Screen Management class facilitates switching between screens
class ScreenManagement(ScreenManager):
    def __init__(self, **kwargs):
        super(ScreenManagement, self).__init__(**kwargs)

class MainWindow(Screen):
    def __init__(self, **kwargs):
        super(MainWindow, self).__init__(**kwargs)


        self.load_screen()
        self.main_loop = Clock.schedule_interval(self.change_loop, 0.1)

    def load_screen(self):
        # TODO Make it configurable        
        self.main_box = BoxLayout(orientation="vertical", padding=[10,0],size=(self.width,self.height))#, pos_hint={'x':1,'y':1})

        self.add_widget(self.main_box)

    def change_loop(self,dt):
        # Clock Update Function
        pass

    def template_popup(self):
        popup_layout = GridLayout(cols = 1, padding = 10)

        #popup_layout.add_widget(...)     
        
        # background=white_background_path # self.status_label_font_size) # title_color=cyngn_button_color,
        self.temp_popup = Popup(title ='Template Popup',
                    content = popup_layout, background_color=[1,1,1,1],auto_dismiss = False, title_size = '20sp')
        
        anim = Animation(background_color=[1,1,1,1], d=1.5) + Animation(background_color=[0,0,0,0], d=2) + Animation(background_color=[1,1,1,1], d=1)
        anim.repeat = True
        self.temp_popup.open()   
        anim.start(self.temp_popup)

class TemplateApp(App):
    def build(self):
        sm = ScreenManagement(transition=SlideTransition())#SwapTransition(duration= 0.5))
        Window.size = (544,960)
        # Window.borderless = True
        # Window.multisamples = 8
        sm.add_widget(MainWindow(name='main'))
        return sm
    

if __name__ == "__main__":
    print("STARTING GUI")
    TemplateApp.run()