﻿#pragma checksum "C:\Users\m0rg0_000\Documents\GitHub\donor\wp7-donor\Donor\ProfileLogin.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "E1BE49B5860DDB435C642C802D67DBD2"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18010
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
        
        internal System.Windows.Controls.StackPanel UserProfile;
        
        internal System.Windows.Controls.TextBlock ProfileName;
        
        internal System.Windows.Controls.TextBlock SecondName;
        
        internal System.Windows.Controls.TextBlock Birthday;
        
        internal System.Windows.Controls.TextBlock ProfileSex;
        
        internal System.Windows.Controls.TextBlock ProfileBloodGroup;
        
        internal System.Windows.Controls.StackPanel RegisterForm;
        
        internal System.Windows.Controls.TextBox email1;
        
        internal System.Windows.Controls.PasswordBox password1;
        
        internal System.Windows.Controls.PasswordBox password2;
        
        internal System.Windows.Controls.TextBox name1;
        
        internal System.Windows.Controls.TextBox SecondNameRegister;
        
        internal Microsoft.Phone.Controls.DatePicker UserBirthdayRegister;
        
        internal System.Windows.Controls.StackPanel SexEditGroupCreate;
        
        internal System.Windows.Controls.RadioButton CreateMale;
        
        internal System.Windows.Controls.RadioButton CreateFemale;
        
        internal System.Windows.Controls.Button RegisterButton;
        
        internal System.Windows.Controls.StackPanel LoginForm;
        
        internal System.Windows.Controls.TextBox email;
        
        internal System.Windows.Controls.PasswordBox password;
        
        internal System.Windows.Controls.Button Login;
        
        internal System.Windows.Controls.Button RegisterShowButton;
        
        internal System.Windows.Controls.Button RestorePassword;
        
        internal WPExtensions.AdvancedApplicationBar AppBar;
        
        internal WPExtensions.AdvancedApplicationBarIconButton FacebookButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton FacebookUnlinkingButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton EditButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton DeleteUserButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton SaveEditProfileButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton CancelEditProfileButton;
        
        internal System.Windows.Controls.StackPanel EditProfile;
        
        internal System.Windows.Controls.TextBox EditName;
        
        internal System.Windows.Controls.TextBox EditSecondName;
        
        internal Microsoft.Phone.Controls.DatePicker EditUserBirthday;
        
        internal Microsoft.Phone.Controls.WrapPanel SexEditGroup;
        
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
            this.UserProfile = ((System.Windows.Controls.StackPanel)(this.FindName("UserProfile")));
            this.ProfileName = ((System.Windows.Controls.TextBlock)(this.FindName("ProfileName")));
            this.SecondName = ((System.Windows.Controls.TextBlock)(this.FindName("SecondName")));
            this.Birthday = ((System.Windows.Controls.TextBlock)(this.FindName("Birthday")));
            this.ProfileSex = ((System.Windows.Controls.TextBlock)(this.FindName("ProfileSex")));
            this.ProfileBloodGroup = ((System.Windows.Controls.TextBlock)(this.FindName("ProfileBloodGroup")));
            this.RegisterForm = ((System.Windows.Controls.StackPanel)(this.FindName("RegisterForm")));
            this.email1 = ((System.Windows.Controls.TextBox)(this.FindName("email1")));
            this.password1 = ((System.Windows.Controls.PasswordBox)(this.FindName("password1")));
            this.password2 = ((System.Windows.Controls.PasswordBox)(this.FindName("password2")));
            this.name1 = ((System.Windows.Controls.TextBox)(this.FindName("name1")));
            this.SecondNameRegister = ((System.Windows.Controls.TextBox)(this.FindName("SecondNameRegister")));
            this.UserBirthdayRegister = ((Microsoft.Phone.Controls.DatePicker)(this.FindName("UserBirthdayRegister")));
            this.SexEditGroupCreate = ((System.Windows.Controls.StackPanel)(this.FindName("SexEditGroupCreate")));
            this.CreateMale = ((System.Windows.Controls.RadioButton)(this.FindName("CreateMale")));
            this.CreateFemale = ((System.Windows.Controls.RadioButton)(this.FindName("CreateFemale")));
            this.RegisterButton = ((System.Windows.Controls.Button)(this.FindName("RegisterButton")));
            this.LoginForm = ((System.Windows.Controls.StackPanel)(this.FindName("LoginForm")));
            this.email = ((System.Windows.Controls.TextBox)(this.FindName("email")));
            this.password = ((System.Windows.Controls.PasswordBox)(this.FindName("password")));
            this.Login = ((System.Windows.Controls.Button)(this.FindName("Login")));
            this.RegisterShowButton = ((System.Windows.Controls.Button)(this.FindName("RegisterShowButton")));
            this.RestorePassword = ((System.Windows.Controls.Button)(this.FindName("RestorePassword")));
            this.AppBar = ((WPExtensions.AdvancedApplicationBar)(this.FindName("AppBar")));
            this.FacebookButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("FacebookButton")));
            this.FacebookUnlinkingButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("FacebookUnlinkingButton")));
            this.EditButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("EditButton")));
            this.DeleteUserButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("DeleteUserButton")));
            this.SaveEditProfileButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("SaveEditProfileButton")));
            this.CancelEditProfileButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("CancelEditProfileButton")));
            this.EditProfile = ((System.Windows.Controls.StackPanel)(this.FindName("EditProfile")));
            this.EditName = ((System.Windows.Controls.TextBox)(this.FindName("EditName")));
            this.EditSecondName = ((System.Windows.Controls.TextBox)(this.FindName("EditSecondName")));
            this.EditUserBirthday = ((Microsoft.Phone.Controls.DatePicker)(this.FindName("EditUserBirthday")));
            this.SexEditGroup = ((Microsoft.Phone.Controls.WrapPanel)(this.FindName("SexEditGroup")));
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
        }
    }
}

