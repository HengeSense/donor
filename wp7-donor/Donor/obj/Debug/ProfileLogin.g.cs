﻿#pragma checksum "C:\Users\root\Documents\GitHub\donor\wp7-donor\Donor\ProfileLogin.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "66EFB4F00C00497A3E1864EB5B46DCE7"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.17626
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

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
using WPExtensions;


namespace Donor {
    
    
    public partial class ProfileLogin : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal Microsoft.Phone.Controls.PerformanceProgressBar LoadingBar;
        
        internal System.Windows.Controls.StackPanel EditProfile;
        
        internal System.Windows.Controls.TextBox EditName;
        
        internal System.Windows.Controls.StackPanel SexEditGroup;
        
        internal System.Windows.Controls.RadioButton EditMale;
        
        internal System.Windows.Controls.RadioButton EditFemale;
        
        internal Microsoft.Phone.Controls.WrapPanel BloudTypeGroupEdit;
        
        internal System.Windows.Controls.RadioButton o;
        
        internal System.Windows.Controls.RadioButton a;
        
        internal System.Windows.Controls.RadioButton b;
        
        internal System.Windows.Controls.RadioButton ab;
        
        internal System.Windows.Controls.StackPanel RHedit;
        
        internal System.Windows.Controls.RadioButton EditRHpl;
        
        internal System.Windows.Controls.RadioButton EditRHd;
        
        internal System.Windows.Controls.StackPanel UserProfile;
        
        internal System.Windows.Controls.TextBlock ProfileName;
        
        internal System.Windows.Controls.TextBlock ProfileSex;
        
        internal System.Windows.Controls.TextBlock ProfileBloodGroup;
        
        internal System.Windows.Controls.StackPanel RegisterForm;
        
        internal System.Windows.Controls.TextBox login1;
        
        internal System.Windows.Controls.TextBox email1;
        
        internal System.Windows.Controls.PasswordBox password1;
        
        internal System.Windows.Controls.PasswordBox password2;
        
        internal System.Windows.Controls.TextBox name1;
        
        internal System.Windows.Controls.Button RegisterButton;
        
        internal System.Windows.Controls.StackPanel LoginForm;
        
        internal System.Windows.Controls.TextBox email;
        
        internal System.Windows.Controls.PasswordBox password;
        
        internal System.Windows.Controls.Button Login;
        
        internal System.Windows.Controls.Button RestorePassword;
        
        internal WPExtensions.AdvancedApplicationBar AppBar;
        
        internal WPExtensions.AdvancedApplicationBarIconButton EditButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton DeleteUserButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton SaveEditProfileButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton CancelEditProfileButton;
        
        internal Microsoft.Phone.Controls.ToggleSwitch PasswordCheck;
        
        internal Microsoft.Phone.Controls.ToggleSwitch PushCheck;
        
        internal Microsoft.Phone.Controls.ToggleSwitch SearchCheck;
        
        internal Microsoft.Phone.Controls.ToggleSwitch BeforeCheck;
        
        internal Microsoft.Phone.Controls.ToggleSwitch AfterCheck;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/ProfileLogin.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.LoadingBar = ((Microsoft.Phone.Controls.PerformanceProgressBar)(this.FindName("LoadingBar")));
            this.EditProfile = ((System.Windows.Controls.StackPanel)(this.FindName("EditProfile")));
            this.EditName = ((System.Windows.Controls.TextBox)(this.FindName("EditName")));
            this.SexEditGroup = ((System.Windows.Controls.StackPanel)(this.FindName("SexEditGroup")));
            this.EditMale = ((System.Windows.Controls.RadioButton)(this.FindName("EditMale")));
            this.EditFemale = ((System.Windows.Controls.RadioButton)(this.FindName("EditFemale")));
            this.BloudTypeGroupEdit = ((Microsoft.Phone.Controls.WrapPanel)(this.FindName("BloudTypeGroupEdit")));
            this.o = ((System.Windows.Controls.RadioButton)(this.FindName("o")));
            this.a = ((System.Windows.Controls.RadioButton)(this.FindName("a")));
            this.b = ((System.Windows.Controls.RadioButton)(this.FindName("b")));
            this.ab = ((System.Windows.Controls.RadioButton)(this.FindName("ab")));
            this.RHedit = ((System.Windows.Controls.StackPanel)(this.FindName("RHedit")));
            this.EditRHpl = ((System.Windows.Controls.RadioButton)(this.FindName("EditRHpl")));
            this.EditRHd = ((System.Windows.Controls.RadioButton)(this.FindName("EditRHd")));
            this.UserProfile = ((System.Windows.Controls.StackPanel)(this.FindName("UserProfile")));
            this.ProfileName = ((System.Windows.Controls.TextBlock)(this.FindName("ProfileName")));
            this.ProfileSex = ((System.Windows.Controls.TextBlock)(this.FindName("ProfileSex")));
            this.ProfileBloodGroup = ((System.Windows.Controls.TextBlock)(this.FindName("ProfileBloodGroup")));
            this.RegisterForm = ((System.Windows.Controls.StackPanel)(this.FindName("RegisterForm")));
            this.login1 = ((System.Windows.Controls.TextBox)(this.FindName("login1")));
            this.email1 = ((System.Windows.Controls.TextBox)(this.FindName("email1")));
            this.password1 = ((System.Windows.Controls.PasswordBox)(this.FindName("password1")));
            this.password2 = ((System.Windows.Controls.PasswordBox)(this.FindName("password2")));
            this.name1 = ((System.Windows.Controls.TextBox)(this.FindName("name1")));
            this.RegisterButton = ((System.Windows.Controls.Button)(this.FindName("RegisterButton")));
            this.LoginForm = ((System.Windows.Controls.StackPanel)(this.FindName("LoginForm")));
            this.email = ((System.Windows.Controls.TextBox)(this.FindName("email")));
            this.password = ((System.Windows.Controls.PasswordBox)(this.FindName("password")));
            this.Login = ((System.Windows.Controls.Button)(this.FindName("Login")));
            this.RestorePassword = ((System.Windows.Controls.Button)(this.FindName("RestorePassword")));
            this.AppBar = ((WPExtensions.AdvancedApplicationBar)(this.FindName("AppBar")));
            this.EditButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("EditButton")));
            this.DeleteUserButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("DeleteUserButton")));
            this.SaveEditProfileButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("SaveEditProfileButton")));
            this.CancelEditProfileButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("CancelEditProfileButton")));
            this.PasswordCheck = ((Microsoft.Phone.Controls.ToggleSwitch)(this.FindName("PasswordCheck")));
            this.PushCheck = ((Microsoft.Phone.Controls.ToggleSwitch)(this.FindName("PushCheck")));
            this.SearchCheck = ((Microsoft.Phone.Controls.ToggleSwitch)(this.FindName("SearchCheck")));
            this.BeforeCheck = ((Microsoft.Phone.Controls.ToggleSwitch)(this.FindName("BeforeCheck")));
            this.AfterCheck = ((Microsoft.Phone.Controls.ToggleSwitch)(this.FindName("AfterCheck")));
        }
    }
}

