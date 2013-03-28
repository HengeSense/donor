using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;
using Donor.ViewModels;
using System.Collections.ObjectModel;

namespace Donor
{
    public partial class AchievesPage : PhoneApplicationPage
    {
        public AchievesPage()
        {
            InitializeComponent();
        }

        private void ListBox_Loaded(object sender, RoutedEventArgs e)
        {
            this.AvailableBadges.ItemsSource = BadgesViewModel.AvailableAchieves;
            this.SoonBadges.ItemsSource = BadgesViewModel.SoonAchieves;
        }

        private void AvailableBadges_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                if ((this.AvailableBadges.SelectedItem as AchieveItem).Status == true)
                {
                    BadgesViewModel.ShowBadgeMessage();
                };
            }
            catch { };            
        }
    }
}