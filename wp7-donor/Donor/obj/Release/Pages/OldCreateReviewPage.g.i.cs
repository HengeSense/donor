﻿#pragma checksum "C:\Users\m0rg0_000\Documents\GitHub\donor\wp7-donor\Donor\Pages\OldCreateReviewPage.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "BCC9CE5599CB14C29BD0756EBADE80F4"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18033
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
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
    
    
    public partial class CreateReviewPage : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal System.Windows.Controls.StackPanel TitlePanel;
        
        internal System.Windows.Controls.TextBlock ApplicationTitle;
        
        internal System.Windows.Controls.TextBlock PageTitle;
        
        internal System.Windows.Controls.Grid ContentPanel;
        
        internal System.Windows.Controls.TextBox UserName;
        
        internal Donor.Controls.VotesControl vote_registry;
        
        internal Donor.Controls.VotesControl vote_physician;
        
        internal Donor.Controls.VotesControl vote_laboratory;
        
        internal Donor.Controls.VotesControl vote_buffet;
        
        internal Donor.Controls.VotesControl vote_schedule;
        
        internal Donor.Controls.VotesControl vote_organization_donation;
        
        internal Donor.Controls.VotesControl vote_room;
        
        internal System.Windows.Controls.TextBox Body;
        
        internal System.Windows.Controls.TextBlock VoteText;
        
        internal System.Windows.Controls.TextBox Vote;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Donor;component/Pages/OldCreateReviewPage.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.TitlePanel = ((System.Windows.Controls.StackPanel)(this.FindName("TitlePanel")));
            this.ApplicationTitle = ((System.Windows.Controls.TextBlock)(this.FindName("ApplicationTitle")));
            this.PageTitle = ((System.Windows.Controls.TextBlock)(this.FindName("PageTitle")));
            this.ContentPanel = ((System.Windows.Controls.Grid)(this.FindName("ContentPanel")));
            this.UserName = ((System.Windows.Controls.TextBox)(this.FindName("UserName")));
            this.vote_registry = ((Donor.Controls.VotesControl)(this.FindName("vote_registry")));
            this.vote_physician = ((Donor.Controls.VotesControl)(this.FindName("vote_physician")));
            this.vote_laboratory = ((Donor.Controls.VotesControl)(this.FindName("vote_laboratory")));
            this.vote_buffet = ((Donor.Controls.VotesControl)(this.FindName("vote_buffet")));
            this.vote_schedule = ((Donor.Controls.VotesControl)(this.FindName("vote_schedule")));
            this.vote_organization_donation = ((Donor.Controls.VotesControl)(this.FindName("vote_organization_donation")));
            this.vote_room = ((Donor.Controls.VotesControl)(this.FindName("vote_room")));
            this.Body = ((System.Windows.Controls.TextBox)(this.FindName("Body")));
            this.VoteText = ((System.Windows.Controls.TextBlock)(this.FindName("VoteText")));
            this.Vote = ((System.Windows.Controls.TextBox)(this.FindName("Vote")));
            this.AppBar = ((WPExtensions.AdvancedApplicationBar)(this.FindName("AppBar")));
            this.SaveButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("SaveButton")));
            this.CancelButton = ((WPExtensions.AdvancedApplicationBarIconButton)(this.FindName("CancelButton")));
        }
    }
}

