﻿#pragma checksum "C:\Users\m0rg0_000\Documents\GitHub\donor\wp7-donor\Donor\EventEditPage.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "559402658BF298FEE0D0410578493631"
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
    
    
    public partial class EventEditPage : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal System.Windows.Controls.StackPanel TitlePanel;
        
        internal System.Windows.Controls.TextBlock ApplicationTitle;
        
        internal System.Windows.Controls.Grid ContentPanel;
        
        internal Microsoft.Phone.Controls.ListPicker EventType;
        
        internal Microsoft.Phone.Controls.ListPicker GiveType;
        
        internal Microsoft.Phone.Controls.DatePicker Date;
        
        internal Microsoft.Phone.Controls.TimePicker Time;
        
        internal System.Windows.Controls.TextBox Place;
        
        internal System.Windows.Controls.StackPanel Reminder;
        
        internal Microsoft.Phone.Controls.ListPicker ReminderPeriod;
        
        internal System.Windows.Controls.CheckBox KnowAboutResults;
        
        internal System.Windows.Controls.ScrollViewer InputScrollViewer;
        
        internal System.Windows.Controls.TextBox Description;
        
        internal WPExtensions.AdvancedApplicationBar AppBar;
        
        internal WPExtensions.AdvancedApplicationBarIconButton SaveButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton CancelButton;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/EventEditPage.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.TitlePanel = ((System.Windows.Controls.StackPanel)(this.FindName("TitlePanel")));
            this.ApplicationTitle = ((System.Windows.Controls.TextBlock)(this.FindName("ApplicationTitle")));
            this.ContentPanel = ((System.Windows.Controls.Grid)(this.FindName("ContentPanel")));
            this.EventType = ((Microsoft.Phone.Controls.ListPicker)(this.FindName("EventType")));
            this.GiveType = ((Microsoft.Phone.Controls.ListPicker)(this.FindName("GiveType")));
            this.Date = ((Microsoft.Phone.Controls.DatePicker)(this.FindName("Date")));
            this.Time = ((Microsoft.Phone.Controls.TimePicker)(this.FindName("Time")));
            this.Place = ((System.Windows.Controls.TextBox)(this.FindName("Place")));
            this.Reminder = ((System.Windows.Controls.StackPanel)(this.FindName("Reminder")));
            this.ReminderPeriod = ((Microsoft.Phone.Controls.ListPicker)(this.FindName("ReminderPeriod")));
            this.KnowAboutResults = ((System.Windows.Controls.CheckBox)(this.FindName("KnowAboutResults")));
            this.InputScrollViewer = ((System.Windows.Controls.ScrollViewer)(this.FindName("InputScrollViewer")));
            this.Description = ((System.Windows.Controls.TextBox)(this.FindName("Description")));
            this.AppBar = ((WPExtensions.AdvancedApplicationBar)(this.FindName("AppBar")));
            this.SaveButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("SaveButton")));
            this.CancelButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("CancelButton")));
        }
    }
}

