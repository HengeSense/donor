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
using RestSharp;
using System.Collections.ObjectModel;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.ComponentModel;
using System.Linq;
using GalaSoft.MvvmLight;

namespace Donor.ViewModels
{
    public class ReviewsListViewModel: ViewModelBase
    {
        public ReviewsListViewModel()
        {
            this.Items = new ObservableCollection<ReviewsViewModel>();
        }

        public delegate void ReviewsLoadedEventHandler(object sender, EventArgs e);
        public event ReviewsLoadedEventHandler ReviewsLoaded;
        protected virtual void OnReviewsLoaded(EventArgs e)
        {
            if (ReviewsLoaded != null)
                ReviewsLoaded(this, e);
        }

        /// <summary>
        /// Загружаем список отзывов о станции, с идентификатором,
        /// соответствующим первому параметру
        /// </summary>
        /// <param name="StationId">
        /// Идентификатор переливания станции
        /// </param>
        public void LoadReviewsForStation(string StationId)
        {
            var bw = new BackgroundWorker();
            
            bw.DoWork += delegate
            {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/YAStations_rating?where={\"station_id\":" + Uri.EscapeUriString(StationId.ToString().ToLower()) + "}&norder=-createdTimestamp", Method.GET);
            request.Parameters.Clear();
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

            client.ExecuteAsync(request, response =>
            {
                try
                {
                    ObservableCollection<ReviewsViewModel> reviewslist1 = new ObservableCollection<ReviewsViewModel>();
                    JObject o = JObject.Parse(response.Content.ToString());
                    reviewslist1 = JsonConvert.DeserializeObject<ObservableCollection<ReviewsViewModel>>(o["results"].ToString());
                    var reviewslist2 = (from reviews in reviewslist1
                                        where (reviews.Station_id.ToString() == StationId.ToString())
                                        orderby reviews.CreatedAt descending
                                        select reviews);
                    reviewslist1 = new ObservableCollection<ReviewsViewModel>();
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        Items = new ObservableCollection<ReviewsViewModel>(reviewslist2);
                        RaisePropertyChanged("Items");
                        
                        this.OnReviewsLoaded(EventArgs.Empty);
                    });
                }
                catch
                {
                };
                
            });
            Deployment.Current.Dispatcher.BeginInvoke(() =>
            {
                RaisePropertyChanged("Items");
            });
            };
            bw.RunWorkerAsync();              
        }

        private ObservableCollection<ReviewsViewModel> _items = new ObservableCollection<ReviewsViewModel>();
        public ObservableCollection<ReviewsViewModel> Items {
            get
            {
                return _items;
            }
            set
            {
                _items = value;
                RaisePropertyChanged("Items");
            }
        }
    }

    /// <summary>
    /// Единичный отзыв пользователя на станцию переливания
    /// </summary>
    public class ReviewsViewModel: ViewModelBase
    {
        public ReviewsViewModel()
        {
        }

        private string _user_id = "";
        /// <summary>
        /// ObjectID идентификатор пользователя, оставившего комментарий
        /// </summary>
        public string User_id
        {
            get
            {
                return _user_id;
            }
            set
            {
                if (_user_id != value)
                {
                    _user_id = value;
                    RaisePropertyChanged("User_id");
                };
            }
        }

        private string _station_id = "";
        /// <summary>
        /// ObjectID идентификатор станции, к которому был оставлен комментарий (отзыв) пользователя
        /// </summary>
        public string Station_id
        {
            get
            {
                return _station_id;
            }
            set
            {
                if (_station_id != value)
                {
                    _station_id = value;
                    RaisePropertyChanged("Station_id");
                };
            }
        }

        private string _comment = "";
        /// <summary>
        /// Текст отзыва к станции
        /// </summary>
        public string Comment {
            get
            {
                return _comment;
            }
            set
            {
                if (_comment != value)
                {
                    _comment = value;
                    RaisePropertyChanged("Comment");
                };
            }
        }

        private int _rate = 3;
        /// <summary>
        /// Оценка станции, от 1 до 5
        /// </summary>
        public int Rate {
            get
            {
                return _rate;
            }
            set
            {
                if (_rate != value)
                {
                    _rate = value;
                    RaisePropertyChanged("Rate");
                };
            }
        }

        /*public string ShortDateText
        {
            private set { }
            get
            {
                try
                {
                    DateTime created = DateTime.Parse(this.Created);
                    return created.ToShortDateString();
                }
                catch {
                    return DateTime.Now.ToShortDateString();
                };
            }
        }*/


        public string UpdatedAt { get; set; }
        public string CreatedAt { get; set; }

        /*public DateTime Date { get; set; }
        public string Created { get; set; }
        public Int64 CreatedTimestamp { get; set; }*/
    }

}
