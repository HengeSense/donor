﻿#pragma checksum "C:\Users\m0rg0_000\Documents\GitHub\donor\wp7-donor\Donor\CalendarMonthPage.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "2092A90AABE88C50AE22944E9E05C466"
//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан программой.
//     Исполняемая версия:4.0.30319.18033
//
//     Изменения в этом файле могут привести к неправильной работе и будут потеряны в случае
//     повторной генерации кода.
// </auto-generated>
//------------------------------------------------------------------------------

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
using WPExtensions;


namespace Donor {
    
    
    public partial class CalendarMonthPage : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Media.Animation.Storyboard ToLeft;
        
        internal System.Windows.Media.Animation.Storyboard fadeIn;
        
        internal System.Windows.Media.Animation.Storyboard fadeOut;
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal System.Windows.Controls.StackPanel TitlePanel;
        
        internal Microsoft.Phone.Controls.PerformanceProgressBar LoadingBar;
        
        internal System.Windows.Controls.TextBlock ApplicationTitle;
        
        internal System.Windows.Controls.TextBlock PageTitle;
        
        internal System.Windows.Controls.Grid ContentPanel;
        
        internal Donor.Controls.MonthCalendar Calendar1;
        
        internal WPExtensions.AdvancedApplicationBar AppBar;
        
        internal WPExtensions.AdvancedApplicationBarIconButton TodayButton;
        
        internal WPExtensions.AdvancedApplicationBarIconButton AddEventButton;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/CalendarMonthPage.xaml", System.UriKind.Relative));
            this.ToLeft = ((System.Windows.Media.Animation.Storyboard)(this.FindName("ToLeft")));
            this.fadeIn = ((System.Windows.Media.Animation.Storyboard)(this.FindName("fadeIn")));
            this.fadeOut = ((System.Windows.Media.Animation.Storyboard)(this.FindName("fadeOut")));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.TitlePanel = ((System.Windows.Controls.StackPanel)(this.FindName("TitlePanel")));
            this.LoadingBar = ((Microsoft.Phone.Controls.PerformanceProgressBar)(this.FindName("LoadingBar")));
            this.ApplicationTitle = ((System.Windows.Controls.TextBlock)(this.FindName("ApplicationTitle")));
            this.PageTitle = ((System.Windows.Controls.TextBlock)(this.FindName("PageTitle")));
            this.ContentPanel = ((System.Windows.Controls.Grid)(this.FindName("ContentPanel")));
            this.Calendar1 = ((Donor.Controls.MonthCalendar)(this.FindName("Calendar1")));
            this.AppBar = ((WPExtensions.AdvancedApplicationBar)(this.FindName("AppBar")));
            this.TodayButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("TodayButton")));
            this.AddEventButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("AddEventButton")));
        }
    }
}

