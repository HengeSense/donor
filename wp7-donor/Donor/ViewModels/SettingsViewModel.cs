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
using System.Collections.Generic;

namespace Donor.ViewModels
{
    public class SettingsViewModel
    {
        public SettingsViewModel()
        {
            PossibleTypes = new List<string>();
        }

        public bool Password = false;
        public bool Push = false;

        public bool FastSearch = false;
        public bool EventBefore = false;
        public bool EventAfter = false;

        List<string> PossibleTypes { get; set; }

        public DateTime StationsUpdated { get; set; }
    }
}
