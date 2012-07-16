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

        public bool Password { get; set; }
        public bool Push { get; set; }

        public bool FastSearch { get; set; }
        public bool EventBefore { get; set; }
        public bool EventAfter { get; set; }

        List<string> PossibleTypes { get; set; } 
    }
}
