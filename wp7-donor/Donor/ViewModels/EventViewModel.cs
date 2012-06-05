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
    public class EventViewModel
    {
        public EventViewModel()
        {
            this.Date = DateTime.Now;
        }

        public string Id { get; set; }
        public string Title { get; set; }
        public string Description {get; set; }
        public DateTime Date { get; set; }

        public string Image { get; set; }
        public string Type { get; set; }
        public string GiveType { get; set; }
        public string Place { get; set; }

        public DateTime Time { get; set; }
    }

    public class EventsListViewModel
    {
        public EventsListViewModel()
        {
            Items = new ObservableCollection<EventViewModel>();
        }

        public ObservableCollection<EventViewModel> Items { get; set; }
    }
}
