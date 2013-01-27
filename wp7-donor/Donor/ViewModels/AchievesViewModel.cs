using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Collections.ObjectModel;

namespace Donor.ViewModels
{
    public class AchievesViewModel
    {
        public AchievesViewModel()
        {
            this.Items = new ObservableCollection<AchieveItem>();
        }

        public ObservableCollection<AchieveItem> Items;
    }

    public class AchieveItem
    {
        public string Image;
        public string Title;
        public string Description;
    }

}
