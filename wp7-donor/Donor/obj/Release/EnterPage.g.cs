﻿#pragma checksum "C:\Users\m0rg0_000\Documents\GitHub\donor\wp7-donor\Donor\EnterPage.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "83F705C47F8008717A0AEADFE2077BB9"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18033
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


namespace Donor {
    
    
    public partial class EnterPage : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal Microsoft.Phone.Controls.PerformanceProgressBar LoadingBar;
        
        internal System.Windows.Controls.Button Login;
        
        internal System.Windows.Controls.Button FacebookLogin;
        
        internal System.Windows.Controls.Button RegisterShowButton;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/EnterPage.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.LoadingBar = ((Microsoft.Phone.Controls.PerformanceProgressBar)(this.FindName("LoadingBar")));
            this.Login = ((System.Windows.Controls.Button)(this.FindName("Login")));
            this.FacebookLogin = ((System.Windows.Controls.Button)(this.FindName("FacebookLogin")));
            this.RegisterShowButton = ((System.Windows.Controls.Button)(this.FindName("RegisterShowButton")));
        }
    }
}

