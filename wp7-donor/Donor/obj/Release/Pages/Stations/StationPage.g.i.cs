﻿#pragma checksum "C:\Users\m0rg0_000\Documents\GitHub\donor\wp7-donor\Donor\Pages\Stations\StationPage.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "F3410A3D7B67DE96FF3963A2F3894822"
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
using Microsoft.Phone.Controls.Maps;
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
using Telerik.Windows.Controls;
using WPExtensions;


namespace Donor {
    
    
    public partial class StationPage : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal Microsoft.Phone.Controls.Panorama MainPanorama;
        
        internal Microsoft.Phone.Controls.Maps.Map map1;
        
        internal Telerik.Windows.Controls.RadJumpList StationsList;
        
        internal WPExtensions.AdvancedApplicationBar AppBar;
        
        internal WPExtensions.AdvancedApplicationBarIconButton ReviewButton;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/Pages/Stations/StationPage.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.MainPanorama = ((Microsoft.Phone.Controls.Panorama)(this.FindName("MainPanorama")));
            this.map1 = ((Microsoft.Phone.Controls.Maps.Map)(this.FindName("map1")));
            this.StationsList = ((Telerik.Windows.Controls.RadJumpList)(this.FindName("StationsList")));
            this.AppBar = ((WPExtensions.AdvancedApplicationBar)(this.FindName("AppBar")));
            this.ReviewButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("ReviewButton")));
        }
    }
}

