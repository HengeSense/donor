﻿#pragma checksum "C:\Users\root\Documents\GitHub\donor\wp7-donor\Donor\CalendarYearPage.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "931B4BF2D681D536D27D264A9E4E86EB"
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
    
    
    public partial class CalendarPage : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal Microsoft.Phone.Controls.LockablePivot Monthes;
        
        internal Microsoft.Phone.Controls.PivotItem PrevMonth2;
        
        internal System.Windows.Controls.ListBox EventsList2Prev;
        
        internal Microsoft.Phone.Controls.PivotItem PrevMonth;
        
        internal System.Windows.Controls.ListBox EventsListPrev;
        
        internal Microsoft.Phone.Controls.PivotItem ThisMonth;
        
        internal System.Windows.Controls.ListBox EventsList;
        
        internal Microsoft.Phone.Controls.PivotItem NextMonth;
        
        internal System.Windows.Controls.ListBox EventsListNext;
        
        internal Microsoft.Phone.Controls.PivotItem NextMonth2;
        
        internal System.Windows.Controls.ListBox EventsListNext2;
        
        internal WPExtensions.AdvancedApplicationBar AppBar;
        
        internal WPExtensions.AdvancedApplicationBarIconButton AddEventButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton MonthCalendarButton;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/CalendarYearPage.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.Monthes = ((Microsoft.Phone.Controls.LockablePivot)(this.FindName("Monthes")));
            this.PrevMonth2 = ((Microsoft.Phone.Controls.PivotItem)(this.FindName("PrevMonth2")));
            this.EventsList2Prev = ((System.Windows.Controls.ListBox)(this.FindName("EventsList2Prev")));
            this.PrevMonth = ((Microsoft.Phone.Controls.PivotItem)(this.FindName("PrevMonth")));
            this.EventsListPrev = ((System.Windows.Controls.ListBox)(this.FindName("EventsListPrev")));
            this.ThisMonth = ((Microsoft.Phone.Controls.PivotItem)(this.FindName("ThisMonth")));
            this.EventsList = ((System.Windows.Controls.ListBox)(this.FindName("EventsList")));
            this.NextMonth = ((Microsoft.Phone.Controls.PivotItem)(this.FindName("NextMonth")));
            this.EventsListNext = ((System.Windows.Controls.ListBox)(this.FindName("EventsListNext")));
            this.NextMonth2 = ((Microsoft.Phone.Controls.PivotItem)(this.FindName("NextMonth2")));
            this.EventsListNext2 = ((System.Windows.Controls.ListBox)(this.FindName("EventsListNext2")));
            this.AppBar = ((WPExtensions.AdvancedApplicationBar)(this.FindName("AppBar")));
            this.AddEventButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("AddEventButton")));
            this.MonthCalendarButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("MonthCalendarButton")));
        }
    }
}

