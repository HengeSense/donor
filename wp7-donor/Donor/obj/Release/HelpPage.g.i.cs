﻿#pragma checksum "C:\Users\m0rg0_000\Documents\GitHub\donor\wp7-donor\Donor\HelpPage.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "EDBD0938D284F8C1ADAB45B6EC8E4009"
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


namespace Donor {
    
    
    public partial class HelpPage : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal System.Windows.Controls.TextBlock PhoneNumber;
        
        internal System.Windows.Controls.TextBlock Email;
        
        internal System.Windows.Controls.TextBlock Site;
        
        internal System.Windows.Controls.StackPanel TitlePanel;
        
        internal Microsoft.Phone.Controls.AutoCompleteBox ContraSearchText;
        
        internal System.Windows.Controls.ListBox SearchContra;
        
        internal System.Windows.Controls.ListBox AbsContra;
        
        internal System.Windows.Controls.TextBlock RelText;
        
        internal System.Windows.Controls.ListBox RelativeContra;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/HelpPage.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.PhoneNumber = ((System.Windows.Controls.TextBlock)(this.FindName("PhoneNumber")));
            this.Email = ((System.Windows.Controls.TextBlock)(this.FindName("Email")));
            this.Site = ((System.Windows.Controls.TextBlock)(this.FindName("Site")));
            this.TitlePanel = ((System.Windows.Controls.StackPanel)(this.FindName("TitlePanel")));
            this.ContraSearchText = ((Microsoft.Phone.Controls.AutoCompleteBox)(this.FindName("ContraSearchText")));
            this.SearchContra = ((System.Windows.Controls.ListBox)(this.FindName("SearchContra")));
            this.AbsContra = ((System.Windows.Controls.ListBox)(this.FindName("AbsContra")));
            this.RelText = ((System.Windows.Controls.TextBlock)(this.FindName("RelText")));
            this.RelativeContra = ((System.Windows.Controls.ListBox)(this.FindName("RelativeContra")));
        }
    }
}

