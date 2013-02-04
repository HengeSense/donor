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
using Newtonsoft.Json.Linq;
using Coding4Fun.Phone.Controls;
using Donor.Controls;
using Microsoft.Phone.Tasks;
using System.Collections.ObjectModel;
using System.ComponentModel;

namespace Donor.ViewModels
{
    public class AchieveItem : INotifyPropertyChanged
    {
        public AchieveItem()
        {
        }
        private string _title = "";
        public string Title
        {
            get
            {
                return _title;
            }
            set
            {
                _title = value;
                NotifyPropertyChanged("Title");
            }
        }

        private string _api_name = "";
        public string Api_name
        {
            get
            {
                return _api_name;
            }
            set
            {
                _api_name = value;
                NotifyPropertyChanged("Api_name");
            }
        }

        private string _image = "";
        public string Image
        {
            get
            {
                return _image;
            }
            set
            {
                _image = value;
                NotifyPropertyChanged("Image");
                NotifyPropertyChanged("CurrentImage");
            }
        }

        private string _unactiveImage = "";
        public string UnactiveImage
        {
            get
            {
                return _unactiveImage;
            }
            set
            {
                _unactiveImage = value;
                NotifyPropertyChanged("UnactiveImage");
                NotifyPropertyChanged("CurrentImage");
            }
        }

        public string CurrentImage {
            private set 
            {
            }
            get
            {
                if (Status == true)
                {
                    return this.Image;
                }
                else
                {
                    return this.UnactiveImage;
                };
            }
        }
        

        private bool _status = false;
        public bool Status
        {
            get
            {
                return _status;
            }
            set
            {
                _status = value;
                NotifyPropertyChanged("Status");
                NotifyPropertyChanged("CurrentImage");
            }
        }

        public string _description = "";
        public string Description 
        {
            get
            {
                return _image;
            }
            set
            {
                _image = value;
                NotifyPropertyChanged("Description");
            }
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

    static public class BadgesViewModel
    {

        static public string activation_code = "";
        static MessagePrompt messagePrompt;
        static string facebook_id = "";

        static BadgesViewModel()
        {
            AvailableAchieves = new ObservableCollection<AchieveItem>();
            AvailableAchieves.Add(new AchieveItem() { Title = "Друг донора",
                Api_name = "donorfriend",
                UnactiveImage = "/images/achieves/Achive-donor_unavailible.png",
                Image = "/images/achieves/Achive-donor.png" });

            SoonAchieves = new ObservableCollection<AchieveItem>();
            SoonAchieves.Add(new AchieveItem() { Title = "Первая помощь",
                Api_name = "secondblood",
                Image = "/images/achieves/Achive-donor_firstBlood_unavailible.png",
                UnactiveImage = "/images/achieves/Achive-donor_firstBlood_unavailible.png" });
            SoonAchieves.Add(new AchieveItem() { Title = "Два подряд",
                Api_name = "thirdblood",
                Image = "/images/achieves/Achive-donor_secondBlood_unavailible.png",
                UnactiveImage = "/images/achieves/Achive-donor_secondBlood_unavailible.png" });

            App.ViewModel.UserEnter += new MainViewModel.UserEnterEventHandler(BadgesViewModel.UserLoaded);
        }

        private static void UserLoaded(object sender, EventArgs e)
        {
            if (App.ViewModel.User.IsLoggedIn == true)
            {
                GetPlayerAchieves(App.ViewModel.User.FacebookId);
            };
        }

        static private void GetPlayerAchieves(string fb_id = "")
        {
            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {
                try
                {
                    var client_player = new RestClient("http://www.itsbeta.com");
                    var request_player = new RestRequest("s/info/playerid.json", Method.GET);
                    request_player.Parameters.Clear();
                    request_player.AddParameter("access_token", "059db4f010c5f40bf4a73a28222dd3e3");
                    request_player.AddParameter("type", "fb_user_id");
                    request_player.AddParameter("id", fb_id);

                    client_player.ExecuteAsync(request_player, response_player =>
                    {
                        try
                        {
                            JObject o_player = JObject.Parse(response_player.Content.ToString());

                            string player_id = o_player["player_id"].ToString();

                            var client = new RestClient("http://www.itsbeta.com");
                            var request = new RestRequest("s/info/achievements.json", Method.GET);
                            request.Parameters.Clear();
                            request.AddParameter("access_token", "059db4f010c5f40bf4a73a28222dd3e3");
                            request.AddParameter("player_id", player_id);

                            client.ExecuteAsync(request, response =>
                            {
                                try
                                {
                                    JObject o = JObject.Parse(response.Content.ToString());
                                }
                                catch { };
                            });
                        }
                        catch { };
                    });
                }
                catch { };
            };
            bw.RunWorkerAsync();
        }

        static private ObservableCollection<AchieveItem> _availableAchieves = new ObservableCollection<AchieveItem>();
        static public ObservableCollection<AchieveItem> AvailableAchieves
        {
            get
            {
                if (_availableAchieves == null)
                {
                    _availableAchieves = new ObservableCollection<AchieveItem>();
                }
                return _availableAchieves;
            }
            set
            {
                try
                {
                    _availableAchieves = value;
                }
                catch { };
            }
        }

        static private ObservableCollection<AchieveItem> _soonAchieves = new ObservableCollection<AchieveItem>();
        static public ObservableCollection<AchieveItem> SoonAchieves
        {
            get
            {
                if (_soonAchieves == null)
                {
                    _soonAchieves = new ObservableCollection<AchieveItem>();
                }
                return _soonAchieves;
            }
            set
            {
                try
                {
                    _soonAchieves = value;
                }
                catch { };
            }
        }

        /// <summary>
        /// Получение кода активации достижения:
        /// POST http://www.itsbeta.com/s/категория/проект/achieves/postachieve.json
        /// Параметры:
        /// ● access_token: String = токен доступа
        /// ● badge_name: String = шаблон достижения
        /// </summary>
        static public void PostAchieve(string user_id = "", string user_token="")
        {
            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {
                    var client = new RestClient("http://www.itsbeta.com");
                    var request = new RestRequest("s/healthcare/donor/achieves/posttofbonce.json", Method.POST);
                    request.Parameters.Clear();
                    request.AddParameter("access_token", "059db4f010c5f40bf4a73a28222dd3e3");
                    request.AddParameter("user_id", user_id);
                    request.AddParameter("user_token", user_token);
                    request.AddParameter("badge_name", "donorfriend");
                    //for test
                    //request.AddParameter("unique", "f");

                    client.ExecuteAsync(request, response =>
                    {
                        try
                        {
                            JObject o = JObject.Parse(response.Content.ToString());
                            if (o["id"].ToString() != "")
                            {
                                facebook_id = o["fb_id"].ToString();

                                Deployment.Current.Dispatcher.BeginInvoke(() =>
                                {
                                    App.ViewModel.Settings.AchieveDonor = true;
                                    App.ViewModel.Settings.AchieveDonorUser = App.ViewModel.User.objectId;
                                    App.ViewModel.SaveSettingsToStorage();

                                    messagePrompt = new MessagePrompt();
                                    try
                                    {
                                        messagePrompt.Body = new BadgeControl();

                                        Button closeButton = new Button() { Content = "Закрыть" };
                                        Button moreButton = new Button() { Content = "Подробнее" };

                                        closeButton.Click += new RoutedEventHandler(closeButton_Click);
                                        moreButton.Click += new RoutedEventHandler(moreButton_Click);

                                        messagePrompt.ActionPopUpButtons.Clear();
                                        messagePrompt.ActionPopUpButtons.Add(closeButton);
                                        messagePrompt.ActionPopUpButtons.Add(moreButton);
                                    }
                                    catch
                                    {
                                    };

                                    messagePrompt.Show();
                                });
                            };
                        }
                        catch { };
                    });
            };
            bw.RunWorkerAsync();
        }

        static void closeButton_Click(object sender, RoutedEventArgs e)
        {
            messagePrompt.Hide();
        }

        static void moreButton_Click(object sender, RoutedEventArgs e)
        {            
            WebBrowserTask webTask = new WebBrowserTask();
            webTask.Uri = new Uri("http://www.itsbeta.com/s/healthcare/donor/achieves/fb?locale=ru&name=donorfriend&fb_action_ids="+facebook_id);
            webTask.Show();
        }

    }
}
