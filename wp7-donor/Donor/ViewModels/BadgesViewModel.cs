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
using System.Linq;
using GalaSoft.MvvmLight;


namespace Donor.ViewModels
{
    public class AchieveItem: ViewModelBase
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
                RaisePropertyChanged("Title");
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
                RaisePropertyChanged("Api_name");
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
                RaisePropertyChanged("Image");
                RaisePropertyChanged("CurrentImage");
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
                RaisePropertyChanged("UnactiveImage");
                RaisePropertyChanged("CurrentImage");
            }
        }

        public string CurrentImage {
            private set 
            {
            }
            get
            {
                if ((Status == true) && (ViewModelLocator.MainStatic.User.IsLoggedIn))
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
                RaisePropertyChanged("Status");
                RaisePropertyChanged("CurrentImage");
            }
        }

        public string _description = "";
        public string Description 
        {
            get
            {
                return _description;
            }
            set
            {
                _description = value;
                RaisePropertyChanged("Description");
            }
        }
    }

    public class BadgesViewModel: ViewModelBase
    {

        static public string activation_code = "";
        static MessagePrompt messagePrompt;
        static string facebook_id = "";

        public BadgesViewModel()
        {
            AvailableAchieves = new ObservableCollection<AchieveItem>();

            AvailableAchieves.Add(new AchieveItem() { Title = "Друг донора",
                Api_name = "donorfriend",
                UnactiveImage = "/images/achieves/Achive-donor_unavailible.png",
                Status = false,
                Description = "Помочь спасти жизнь",
                Image = "/images/achieves/Achive-donor.png" });

            AvailableAchieves.Add(new AchieveItem()
            {
                Title = "Первая сдача крови",
                Api_name = "first_blood",
                UnactiveImage = "/images/achieves/Achive-donor_unavailible.png",
                Status = false,
                Image = "/images/achieves/Achive-donor.png",
                Description = "Сдал кровь первый раз"
            });            

            SoonAchieves = new ObservableCollection<AchieveItem>();

            SoonAchieves.Add(new AchieveItem()
            {
                Title = "Два подряд",
                Api_name = "secondblood",
                Image = "/images/achieves/Achive-donor_secondBlood_unavailible.png",
                Status = false,
                Description = "Сдал кровь второй раз",
                UnactiveImage = "/images/achieves/Achive-donor_secondBlood_unavailible.png" });

            //ViewModelLocator.MainStatic.UserEnter += new MainViewModel.UserEnterEventHandler(ViewModelLocator.BadgesStatic.UserLoaded);
        }

        public void DisableFirstBlood()
        {
            try
            {
                AvailableAchieves.FirstOrDefault(c => c.Api_name == "first_blood").Status = false;
            }
            catch
            {
            };
        }

        public void UserLoaded(object sender, EventArgs e)
        {
            try
            {
                if (ViewModelLocator.MainStatic.User.IsLoggedIn == true)
                {
                    GetPlayerAchieves(ViewModelLocator.MainStatic.User.FacebookId);
                };
            }
            catch { };
        }

        //public static string ActivateCode = "";
        /*www.itsbeta.com/s/activate.json?activation_code=.....&user_id=....&user_token=......*/
        /// <summary>
        /// 
        /// </summary>
        /// <param name="activation_code"></param>
        public void ActivateAchieve(string activation_code)
        {
            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {
                var client = new RestClient("http://www.itsbeta.com");
                var request = new RestRequest("s/activate.json", Method.GET);
                request.Parameters.Clear();
                request.AddParameter("access_token", App.ACCESS_TOKEN);
                request.AddParameter("user_id", ViewModelLocator.MainStatic.User.FacebookId);
                request.AddParameter("user_token", ViewModelLocator.MainStatic.User.FacebookToken);
                request.AddParameter("activation_code", activation_code);
                request.AddParameter("unique", "f");
                client.ExecuteAsync(request, response =>
                {
                    try
                    {
                        JObject o = JObject.Parse(response.Content.ToString());
                        if (o["id"].ToString() != "")
                        {
                            Deployment.Current.Dispatcher.BeginInvoke(() =>
                            {
                                //ViewModelLocator.MainStatic.LoadAchievements(o["api_name"].ToString());
                                GetPlayerAchieves(ViewModelLocator.MainStatic.User.FacebookId);
                            });
                        }
                        else
                        {
                            Deployment.Current.Dispatcher.BeginInvoke(() =>
                            {
                            });
                        };
                    }
                    catch
                    {
                        try
                        {
                            JObject o = JObject.Parse(response.Content.ToString());
                            if (o["error"].ToString() == "406")
                            {
                                Deployment.Current.Dispatcher.BeginInvoke(() =>
                                {
                                    //ViewModelLocator.UserStatic.AchievedEarnedMessage(AppResources.Error406activated);
                                });
                            }
                            else
                            {
                                Deployment.Current.Dispatcher.BeginInvoke(() =>
                                {
                                    //ViewModelLocator.UserStatic.AchievedEarnedMessage(AppResources.ErrorCantActivate);
                                });
                            };
                        }
                        catch
                        {
                            Deployment.Current.Dispatcher.BeginInvoke(() =>
                            {
                            });
                        };

                    };
                });
            };
            bw.RunWorkerAsync();
        }

        private AchieveItem _currentBadge = new AchieveItem();
        public AchieveItem CurrentBadge
        {
            set
            {
                if (_currentBadge != value)
                {
                    _currentBadge = value;
                    RaisePropertyChanged("CurrentBadge");
                }
            }
            get
            {
                return _currentBadge;
            }
        }

        private void GetPlayerAchieves(string fb_id = "")
        {
            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {
                try
                {
                    var client_player = new RestClient("http://www.itsbeta.com");
                    var request_player = new RestRequest("s/info/playerid.json", Method.GET);
                    request_player.Parameters.Clear();
                    request_player.AddParameter("access_token", App.ACCESS_TOKEN);
                    request_player.AddParameter("type", "fb_user_id");
                    request_player.AddParameter("id", fb_id);

                    client_player.ExecuteAsync(request_player, response_player =>
                    {
                        try
                        {
                            JObject o_player = JObject.Parse(response_player.Content.ToString());

                            string player_id = o_player["player_id"].ToString();

                            var client = new RestClient("http://www.itsbeta.com");
                            var request = new RestRequest("s/info/badges.json", Method.GET);
                            request.Parameters.Clear();
                            request.AddParameter("access_token", "059db4f010c5f40bf4a73a28222dd3e3");
                            request.AddParameter("player_id", player_id);
                            request.AddParameter("project_id", "50d78a38d870307e9b000002");

                            client.ExecuteAsync(request, response =>
                            {
                                try
                                {
                                    JArray o = JArray.Parse(response.Content.ToString());
                                    foreach (var item in o) {
                                        string activated = "";
                                        activated = item["activated"].ToString();
                                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                                        {
                                            try
                                            {
                                                AvailableAchieves.FirstOrDefault(c => c.Api_name == item["api_name"].ToString()).Title = item["display_name"].ToString();
                                            }
                                            catch { };
                                        });
                                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                                        {
                                            try {SoonAchieves.FirstOrDefault(c => c.Api_name == item["api_name"].ToString()).Title = item["display_name"].ToString();} catch { };
                                        });
                                        if (activated == "True")
                                        {
                                            Deployment.Current.Dispatcher.BeginInvoke(() =>
                                            {
                                                try
                                                {
                                                    AvailableAchieves.FirstOrDefault(c => c.Api_name == item["api_name"].ToString()).Status = true;
                                                }
                                                catch {};
                                            });
                                        };
                                    };
                                    RaisePropertyChanged("AvailableAchieves");
                                }
                                catch { };
                                RaisePropertyChanged("AvailableAchieves");
                            });
                        }
                        catch { };
                    });
                }
                catch { };
            };
            bw.RunWorkerAsync();
        }

        public void ClearStatus()
        {
            foreach (var item in AvailableAchieves)
            {
                item.Status = false;
            };
        }

        private ObservableCollection<AchieveItem> _availableAchieves = new ObservableCollection<AchieveItem>();
        public ObservableCollection<AchieveItem> AvailableAchieves
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
                    RaisePropertyChanged("AvailableAchieves");
                }
                catch { };
            }
        }

        private ObservableCollection<AchieveItem> _soonAchieves = new ObservableCollection<AchieveItem>();
        public ObservableCollection<AchieveItem> SoonAchieves
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
                    RaisePropertyChanged("SoonAchieves");
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
        public void PostAchieve(string user_id = "", string user_token="")
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

                            try
                            {
                                if (o["error"].ToString() == "404")
                                {
                                    ViewModelLocator.MainStatic.Settings.AchieveDonor = true;
                                    ViewModelLocator.MainStatic.Settings.AchieveDonorUser = ViewModelLocator.MainStatic.User.objectId;
                                    ViewModelLocator.MainStatic.SaveSettingsToStorage();
                                };
                            }
                            catch { };

                            if (o["id"].ToString() != "")
                            {
                                facebook_id = o["fb_id"].ToString();

                                Deployment.Current.Dispatcher.BeginInvoke(() =>
                                {
                                    ViewModelLocator.MainStatic.Settings.AchieveDonor = true;
                                    ViewModelLocator.MainStatic.Settings.AchieveDonorUser = ViewModelLocator.MainStatic.User.objectId;
                                    ViewModelLocator.MainStatic.SaveSettingsToStorage();

                                    ViewModelLocator.BadgesStatic.CurrentBadge = ViewModelLocator.BadgesStatic.AvailableAchieves.FirstOrDefault(c=>c.Api_name=="donorfriend");
                                    ViewModelLocator.BadgesStatic.ShowBadgeMessage();
                                });
                            };
                        }
                        catch { };
                    });
            };
            bw.RunWorkerAsync();
        }

        public void ShowBadgeMessage()
        {
            messagePrompt = new MessagePrompt();
            try
            {
                messagePrompt.Body = new AllBadgeControl();

                Button closeButton = new Button() { Content = "Закрыть" };
                Button moreButton = new Button() { Content = "Подробнее" };

                closeButton.Click += new RoutedEventHandler(closeButton_Click);
                moreButton.Click += new RoutedEventHandler(moreButton_Click);

                messagePrompt.ActionPopUpButtons.Clear();
                messagePrompt.ActionPopUpButtons.Add(closeButton);
                if (facebook_id!="") {
                    messagePrompt.ActionPopUpButtons.Add(moreButton);
                };
                
            }
            catch
            {
            };
            messagePrompt.Show();
        }

        void closeButton_Click(object sender, RoutedEventArgs e)
        {
            messagePrompt.Hide();
        }

        void moreButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                WebBrowserTask webTask = new WebBrowserTask();
                webTask.Uri = new Uri("http://www.itsbeta.com/s/healthcare/donor/achieves/fb?locale=ru&name=donorfriend&fb_action_ids=" + facebook_id);
                webTask.Show();
            }
            catch { };
        }

    }
}
