﻿#pragma checksum "C:\Users\m0rg0_000\Documents\GitHub\donor\wp7-donor\Donor\QRread.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "37A2CB46B4C5E0D039ED85C486519B88"
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
    
    
    public partial class QRread : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal System.Windows.Controls.StackPanel TitlePanel;
        
        internal System.Windows.Controls.TextBlock ApplicationTitle;
        
        internal System.Windows.Controls.Grid ContentPanel;
        
        internal System.Windows.Shapes.Rectangle _previewRect;
        
        internal System.Windows.Media.VideoBrush _previewVideo;
        
        internal System.Windows.Media.CompositeTransform _previewTransform;
        
        internal System.Windows.Controls.ListBox _matchesList;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/QRread.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.TitlePanel = ((System.Windows.Controls.StackPanel)(this.FindName("TitlePanel")));
            this.ApplicationTitle = ((System.Windows.Controls.TextBlock)(this.FindName("ApplicationTitle")));
            this.ContentPanel = ((System.Windows.Controls.Grid)(this.FindName("ContentPanel")));
            this._previewRect = ((System.Windows.Shapes.Rectangle)(this.FindName("_previewRect")));
            this._previewVideo = ((System.Windows.Media.VideoBrush)(this.FindName("_previewVideo")));
            this._previewTransform = ((System.Windows.Media.CompositeTransform)(this.FindName("_previewTransform")));
            this._matchesList = ((System.Windows.Controls.ListBox)(this.FindName("_matchesList")));
        }
    }
}

