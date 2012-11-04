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
using System.ComponentModel;
using RestSharp;
using Newtonsoft.Json.Linq;
using MSPToolkit.Utilities;
using Newtonsoft.Json;

namespace Donor.ViewModels
{
    /// <summary>
    /// Противопоказание
    /// </summary>
    public class ContraViewModel
    {
        public ContraViewModel()
        {
        }

        public string ObjectId { get; set; }
        public string Description { get; set; }
        public bool Absolute { get; set; }
        public string Parent_id { get; set; }
        public string Title { get; set; }

        public string CreatedAt { get; set; }
        public string UpdatedAt { get; set; }

        public DateTime Date { get; set; }
    }


    /// <summary>
    /// Управление списком противопоказаний
    /// </summary>
    public class ContraListViewModel : INotifyPropertyChanged
    {
        public ContraListViewModel()
        {
            Items = new ObservableCollection<ContraViewModel>();
        }

        public ObservableCollection<ContraViewModel> Items { get; set; }

        public void LoadContras()
        {
            try
            {
                ObservableCollection<ContraViewModel> contraslist1 = new ObservableCollection<ContraViewModel>();
                contraslist1 = IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<ContraViewModel>>("contras.xml");
                this.Items = contraslist1;
            }
            catch { this.Items = new ObservableCollection<ContraViewModel>(); };

            if ((App.ViewModel.Contras.Items.Count == 0) || (App.ViewModel.Settings.ContrasUpdated.AddDays(7) < DateTime.Now)) {

            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/Contras", Method.GET);
            request.Parameters.Clear();
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
            client.ExecuteAsync(request, response =>
            {
                try
                {
                    var bw = new BackgroundWorker();
                    bw.DoWork += delegate
                    {
                    ObservableCollection<ContraViewModel> contraslist1 = new ObservableCollection<ContraViewModel>();
                    JObject o = JObject.Parse(response.Content.ToString());
                    contraslist1 = JsonConvert.DeserializeObject<ObservableCollection<ContraViewModel>>(o["results"].ToString());
                    
                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            this.Items = contraslist1;

                            IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<ContraViewModel>>(App.ViewModel.Contras.Items, "contras.xml");   

                            App.ViewModel.Settings.ContrasUpdated = DateTime.Now;
                            App.ViewModel.SaveSettingsToStorage();

                            this.NotifyPropertyChanged("Items");
                        });                        
                    };
                    bw.RunWorkerAsync();
                }
                catch
                {
                };
                this.NotifyPropertyChanged("Items");
            });
            } else {};
        }

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String propertyName)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (null != handler)
            {
                handler(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        public void RaisePropertyChanged(string property)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(property));
            }
        }
    }

}
