﻿#pragma checksum "C:\Users\m0rg0_000\Documents\GitHub\donor\wp7-donor\Donor\MainPage.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "9885C60F353B0F48EB64042D3670858E"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.17929
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using Coding4Fun.Phone.Controls;
using Microsoft.Phone.Controls;
using System;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Automation.Peers;
using System.Windows.Automation.Provider;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Interop;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Imaging;
using System.Windows.Resources;
using System.Windows.Shapes;
using System.Windows.Threading;


namespace Donor {
    
    
    public partial class MainPage : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal Coding4Fun.Phone.Controls.ProgressOverlay progressOverlay;
        
        internal Microsoft.Phone.Controls.PerformanceProgressBar Loading;
        
        internal System.Windows.Controls.ListBox mainmenu;
        
        internal System.Windows.Controls.TextBlock CalendarMenuText;
        
        internal System.Windows.Controls.TextBlock StationsMenu;
        
        internal System.Windows.Controls.TextBlock adsMenuText;
        
        internal System.Windows.Controls.TextBlock NewMenuItem;
        
        internal System.Windows.Controls.TextBlock HelpMenuText;
        
        internal System.Windows.Controls.ListBox EventsList;
        
        internal System.Windows.Controls.Button AddEvent;
        
        internal System.Windows.Controls.ListBox NewsList;
        
        internal System.Windows.Controls.StackPanel LoginForm;
        
        internal Microsoft.Phone.Controls.PerformanceProgressBar LoginLoadingBar;
        
        internal System.Windows.Controls.TextBox email;
        
        internal System.Windows.Controls.PasswordBox password;
        
        internal System.Windows.Controls.Button Login;
        
        internal System.Windows.Controls.StackPanel UserProfile;
        
        internal System.Windows.Controls.TextBlock ProfileName;
        
        internal System.Windows.Controls.TextBlock ProfileSex;
        
        internal System.Windows.Controls.TextBlock ProfileBloodGroup;
        
        internal System.Windows.Controls.TextBlock GivedBlood;
        
        internal System.Windows.Controls.Button EditProfile;
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/MainPage.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.progressOverlay = ((Coding4Fun.Phone.Controls.ProgressOverlay)(this.FindName("progressOverlay")));
            this.Loading = ((Microsoft.Phone.Controls.PerformanceProgressBar)(this.FindName("Loading")));
            this.mainmenu = ((System.Windows.Controls.ListBox)(this.FindName("mainmenu")));
            this.CalendarMenuText = ((System.Windows.Controls.TextBlock)(this.FindName("CalendarMenuText")));
            this.StationsMenu = ((System.Windows.Controls.TextBlock)(this.FindName("StationsMenu")));
            this.adsMenuText = ((System.Windows.Controls.TextBlock)(this.FindName("adsMenuText")));
            this.NewMenuItem = ((System.Windows.Controls.TextBlock)(this.FindName("NewMenuItem")));
            this.HelpMenuText = ((System.Windows.Controls.TextBlock)(this.FindName("HelpMenuText")));
            this.EventsList = ((System.Windows.Controls.ListBox)(this.FindName("EventsList")));
            this.AddEvent = ((System.Windows.Controls.Button)(this.FindName("AddEvent")));
            this.NewsList = ((System.Windows.Controls.ListBox)(this.FindName("NewsList")));
            this.LoginForm = ((System.Windows.Controls.StackPanel)(this.FindName("LoginForm")));
            this.LoginLoadingBar = ((Microsoft.Phone.Controls.PerformanceProgressBar)(this.FindName("LoginLoadingBar")));
            this.email = ((System.Windows.Controls.TextBox)(this.FindName("email")));
            this.password = ((System.Windows.Controls.PasswordBox)(this.FindName("password")));
            this.Login = ((System.Windows.Controls.Button)(this.FindName("Login")));
            this.UserProfile = ((System.Windows.Controls.StackPanel)(this.FindName("UserProfile")));
            this.ProfileName = ((System.Windows.Controls.TextBlock)(this.FindName("ProfileName")));
            this.ProfileSex = ((System.Windows.Controls.TextBlock)(this.FindName("ProfileSex")));
            this.ProfileBloodGroup = ((System.Windows.Controls.TextBlock)(this.FindName("ProfileBloodGroup")));
            this.GivedBlood = ((System.Windows.Controls.TextBlock)(this.FindName("GivedBlood")));
            this.EditProfile = ((System.Windows.Controls.Button)(this.FindName("EditProfile")));
        }
    }
}

