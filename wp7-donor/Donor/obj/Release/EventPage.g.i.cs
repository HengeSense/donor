﻿#pragma checksum "C:\Users\m0rg0_000\Documents\GitHub\donor\wp7-donor\Donor\EventPage.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "F573ABCA1FA4BCCA0EE4E3867B1CF656"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.17929
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
    
    
    public partial class EventPage : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal System.Windows.Controls.StackPanel TitlePanel;
        
        internal System.Windows.Controls.TextBlock ApplicationTitle;
        
        internal System.Windows.Controls.Grid ContentPanel;
        
        internal System.Windows.Controls.TextBlock TitleNews;
        
        internal System.Windows.Controls.Image ic_be_tested;
        
        internal System.Windows.Controls.TextBlock Date;
        
        internal System.Windows.Controls.TextBlock Time;
        
        internal System.Windows.Controls.TextBlock GiveType;
        
        internal System.Windows.Controls.TextBlock Place;
        
        internal System.Windows.Controls.Image MapButton;
        
        internal System.Windows.Controls.StackPanel ReminderStackPanel;
        
        internal System.Windows.Controls.TextBlock Reminder;
        
        internal System.Windows.Controls.TextBlock Finished;
        
        internal System.Windows.Controls.TextBlock Description;
        
        internal WPExtensions.AdvancedApplicationBar AppBar;
        
        internal WPExtensions.AdvancedApplicationBarIconButton EditButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton DeleteButton;
        
        internal WPExtensions.AdvancedApplicationBarMenuItem FinishedMenu;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/EventPage.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.TitlePanel = ((System.Windows.Controls.StackPanel)(this.FindName("TitlePanel")));
            this.ApplicationTitle = ((System.Windows.Controls.TextBlock)(this.FindName("ApplicationTitle")));
            this.ContentPanel = ((System.Windows.Controls.Grid)(this.FindName("ContentPanel")));
            this.TitleNews = ((System.Windows.Controls.TextBlock)(this.FindName("TitleNews")));
            this.ic_be_tested = ((System.Windows.Controls.Image)(this.FindName("ic_be_tested")));
            this.Date = ((System.Windows.Controls.TextBlock)(this.FindName("Date")));
            this.Time = ((System.Windows.Controls.TextBlock)(this.FindName("Time")));
            this.GiveType = ((System.Windows.Controls.TextBlock)(this.FindName("GiveType")));
            this.Place = ((System.Windows.Controls.TextBlock)(this.FindName("Place")));
            this.MapButton = ((System.Windows.Controls.Image)(this.FindName("MapButton")));
            this.ReminderStackPanel = ((System.Windows.Controls.StackPanel)(this.FindName("ReminderStackPanel")));
            this.Reminder = ((System.Windows.Controls.TextBlock)(this.FindName("Reminder")));
            this.Finished = ((System.Windows.Controls.TextBlock)(this.FindName("Finished")));
            this.Description = ((System.Windows.Controls.TextBlock)(this.FindName("Description")));
            this.AppBar = ((WPExtensions.AdvancedApplicationBar)(this.FindName("AppBar")));
            this.EditButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("EditButton")));
            this.DeleteButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("DeleteButton")));
            this.FinishedMenu = ((WPExtensions.AdvancedApplicationBarMenuItem)(this.FindName("FinishedMenu")));
        }
    }
}

