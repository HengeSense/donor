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
using System.Net.Http;

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

        public async void LoadContras()
        {
            try
            {
                ObservableCollection<ContraViewModel> contraslist1 = new ObservableCollection<ContraViewModel>();
                contraslist1 = IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<ContraViewModel>>("contras.xml");
                this.Items = contraslist1;
            }
            catch { this.Items = new ObservableCollection<ContraViewModel>(); };

            if ((ViewModelLocator.MainStatic.Contras.Items.Count == 0) || (ViewModelLocator.MainStatic.Settings.ContrasUpdated.AddDays(7) < DateTime.Now)) {

                HttpClient http = new System.Net.Http.HttpClient();
                http.DefaultRequestHeaders.Add("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                http.DefaultRequestHeaders.Add("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                HttpResponseMessage httpresponse =
                    await http.GetAsync("https://api.parse.com/1/classes/Contras");
                string output = await httpresponse.Content.ReadAsStringAsync();

                try
                {
                    ObservableCollection<ContraViewModel> contraslist1 = new ObservableCollection<ContraViewModel>();
                    JObject o = JObject.Parse(output.ToString());
                    contraslist1 = JsonConvert.DeserializeObject<ObservableCollection<ContraViewModel>>(o["results"].ToString());
                    
                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            this.Items = contraslist1;

                            IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<ContraViewModel>>(ViewModelLocator.MainStatic.Contras.Items, "contras.xml");   

                            ViewModelLocator.MainStatic.Settings.ContrasUpdated = DateTime.Now;
                            ViewModelLocator.MainStatic.SaveSettingsToStorage();

                            this.NotifyPropertyChanged("Items");
                        });                        
                }
                catch
                {
                };
                this.NotifyPropertyChanged("Items");
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
