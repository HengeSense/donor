﻿#pragma checksum "C:\Users\m0rg0_000\Documents\GitHub\donor\wp7-donor\Donor\StationPageOld.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "2301E8C5F8479476468B8E3359553153"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18033
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using Coding4Fun.Phone.Controls;
using Donor.Controls;
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
    
    
    public partial class StationPageOld : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal Coding4Fun.Phone.Controls.ProgressOverlay progressOverlay;
        
        internal Microsoft.Phone.Controls.PerformanceProgressBar Loading;
        
        internal Microsoft.Phone.Controls.Panorama MainPanorama;
        
        internal Donor.Controls.VotesControl rate;
        
        internal System.Windows.Controls.StackPanel BloodFor;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/StationPageOld.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.progressOverlay = ((Coding4Fun.Phone.Controls.ProgressOverlay)(this.FindName("progressOverlay")));
            this.Loading = ((Microsoft.Phone.Controls.PerformanceProgressBar)(this.FindName("Loading")));
            this.MainPanorama = ((Microsoft.Phone.Controls.Panorama)(this.FindName("MainPanorama")));
            this.rate = ((Donor.Controls.VotesControl)(this.FindName("rate")));
            this.BloodFor = ((System.Windows.Controls.StackPanel)(this.FindName("BloodFor")));
        }
    }
}

