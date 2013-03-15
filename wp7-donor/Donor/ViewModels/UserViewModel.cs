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
using System.ComponentModel;
using MSPToolkit.Utilities;
using System.Linq;
using RestSharp;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using System.Collections.Generic;
using System.Globalization;
//using Parse;

namespace Donor.ViewModels
{
    public class UserViewModel
    {
    }

    public class DonorUser: INotifyPropertyChanged
    {
        public DonorUser()
        {
            this.IsLoggedIn = false;
            this.loginCommand = new DelegateCommand(this.LoginAction);
            this.updateCommand = new DelegateCommand(this.UpdateAction);
            //this.updateCommand = new DelegateCommand(this.UpdateAction);
        }


        private ICommand loginCommand;
        private ICommand logoutCommand;
        private ICommand updateCommand;

        private bool _userLoading = false;
        /// <summary>
        /// Происходит ли сейчас загрузка данных о пользователе\авторизация
        /// </summary>
        public bool UserLoading
        {
            get
            {
                return _userLoading;
            }
            set
            {
                _userLoading = value;
                NotifyPropertyChanged("UserLoading");
            }
        }


        public void LogoutAction(object p)
        {
            this.IsLoggedIn = false;
            this.UserName = "";
            this.Name = "";
            this.SecondName = ""; 
            this.Password = "";
            this.NotifyAll();

            ViewModelLocator.MainStatic.FbId = "";
            ViewModelLocator.MainStatic.FbToken = "";
            ViewModelLocator.MainStatic.User.Name = "";
            ViewModelLocator.MainStatic.User.SecondName = "";

            //ViewModelLocator.MainStatic.User = new DonorUser();

            ViewModelLocator.MainStatic.User.UserName = "";
            ViewModelLocator.MainStatic.User.Password = "";
            this.NotifyAll();
            BadgesViewModel.ClearStatus();

            ViewModelLocator.MainStatic.SaveUserToStorage();

            ViewModelLocator.MainStatic.Events.UpdateItems();

            ///log event to flurry.com
            List<FlurryWP7SDK.Models.Parameter> articleParams = new List<FlurryWP7SDK.Models.Parameter> { 
                new FlurryWP7SDK.Models.Parameter("objectId", ViewModelLocator.MainStatic.User.objectId), 
                new FlurryWP7SDK.Models.Parameter("platform", "wp7") };
            FlurryWP7SDK.Api.LogEvent("User_logout", articleParams);


            (Application.Current.RootVisual as PhoneApplicationFrame).GoBack();
        }

        /// <summary>
        /// Обновление данных профиля пользователя на parse.com
        /// </summary>
        /// <param name="p"></param>
        public void UpdateAction(object p)
        {
            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/users/" + this.objectId.ToString(), Method.PUT);
                request.AddHeader("Accept", "application/json");
                request.Parameters.Clear();
                string strJSONContent = "{\"username\":\"" + this.UserName + "\", \"email\":\"" + this.UserName + "\", \"Sex\":" + this.Sex + ", \"Name\":\"" + this.Name + "\", \"secondName\":\"" + this.SecondName + "\", \"birthday\": \"" + this.Birthday + "\", \"BloodGroup\":" + this.BloodGroup + ", \"BloodRh\":" + this.BloodRh + "}";
                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                request.AddHeader("X-Parse-Session-Token", ViewModelLocator.MainStatic.User.sessionToken);
                request.AddHeader("Content-Type", "application/json");
                request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

                Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            this.UserLoading = true;
                        });

                client.ExecuteAsync(request, response =>
                {
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            this.UserLoading = false;
                        });
                    try
                    {
                        JObject o = JObject.Parse(response.Content.ToString());
                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            if (o["error"] == null)
                            {
                                try
                                {
                                    if ((int)p == 1)
                                    {
                                    }
                                    else
                                    {
                                        MessageBox.Show("Данные профиля обновлены.");
                                    };
                                }
                                catch
                                {
                                    MessageBox.Show("Данные профиля обновлены.");
                                };
                                ///Обновление профиля пользователя - событие для flurry
                                List<FlurryWP7SDK.Models.Parameter> articleParams = new List<FlurryWP7SDK.Models.Parameter> { 
                                new FlurryWP7SDK.Models.Parameter("objectId", ViewModelLocator.MainStatic.User.objectId), 
                                new FlurryWP7SDK.Models.Parameter("platform", "wp7") };
                                FlurryWP7SDK.Api.LogEvent("User_updated", articleParams);                        
                            }
                            else
                            {
                            };
                            ClassToUser();
                        });
                    }
                    catch
                    {
                    };
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            ViewModelLocator.MainStatic.SaveUserToStorage();
                        });
                });
            };
            bw.RunWorkerAsync();
        }


        public void LoginAction(object p)
        {
            try {
            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {
                Deployment.Current.Dispatcher.BeginInvoke(() =>
                {
                    ViewModelLocator.MainStatic.User.UserLoading = true;
                    ViewModelLocator.MainStatic.User.IsLoggedIn = false;
                });
                string passwordCurrent = this.Password;

                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/login?username=" + Uri.EscapeUriString(this.UserName.ToLower()) + "&password=" + Uri.EscapeUriString(this.Password), Method.GET);
                request.Parameters.Clear();
                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

                

                client.ExecuteAsync(request, response =>
                {
                    try
                    {
                        JObject o = JObject.Parse(response.Content.ToString());
                        if (o["error"] == null)
                        {
                            Deployment.Current.Dispatcher.BeginInvoke(() =>
                            {
                                //auto linking
                                ViewModelLocator.MainStatic.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                                ClassToUser();

                                try
                                {
                                    ViewModelLocator.MainStatic.User.FacebookId = o["authData"]["facebook"]["id"].ToString();
                                    ViewModelLocator.MainStatic.User.FacebookToken = o["authData"]["facebook"]["access_token"].ToString();
                                }
                                catch { };

                                ViewModelLocator.MainStatic.User.IsLoggedIn = true;
                                this.IsLoggedIn = true;
                                this.Password = passwordCurrent;
                                ViewModelLocator.MainStatic.User.Password = passwordCurrent;

                                ViewModelLocator.MainStatic.SaveUserToStorage();

                                ViewModelLocator.MainStatic.Events.WeekItemsUpdated();
                                ViewModelLocator.MainStatic.Events.LoadEventsParse();

                                ViewModelLocator.MainStatic.SaveUserToStorage();

                                ViewModelLocator.MainStatic.User.NotifyAll();
                                //this.NotifyAll();
                                //ClassToUser();

                                ViewModelLocator.MainStatic.OnUserEnter(EventArgs.Empty);
                                FlurryWP7SDK.Api.LogEvent("User_login");

                                if ((ViewModelLocator.MainStatic.FbId != "") && (ViewModelLocator.MainStatic.FbToken != ""))
                                {
                                    ViewModelLocator.MainStatic.User.FacebookLinking(ViewModelLocator.MainStatic.FbId, ViewModelLocator.MainStatic.FbToken);
                                    ViewModelLocator.MainStatic.User.FacebookId = ViewModelLocator.MainStatic.FbId;
                                    ViewModelLocator.MainStatic.User.FacebookToken = ViewModelLocator.MainStatic.FbToken;
                                    ViewModelLocator.MainStatic.FbId = "";
                                    ViewModelLocator.MainStatic.FbToken = "";
                                };
                            });
                        }
                        else
                        {
                            Deployment.Current.Dispatcher.BeginInvoke(() =>
                            {
                                ViewModelLocator.MainStatic.User.IsLoggedIn = false;
                                MessageBox.Show(Donor.AppResources.UncorrectLoginData);

                                ViewModelLocator.MainStatic.User.NotifyAll();
                                this.NotifyAll();
                            });
                        };
                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                            {
                                ViewModelLocator.MainStatic.User.UserLoading = false;
                            });
                    }
                    catch
                    {
                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                            {
                                ViewModelLocator.MainStatic.User.UserLoading = false;
                            });
                    };
                });
            };
            bw.RunWorkerAsync();
            } catch {};
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public delegate void FacebookLinkedEventHandler(object sender, EventArgs e);
        public event FacebookLinkedEventHandler FacebookLinked;
        public virtual void OnFacebookLinked(EventArgs e)
        {
            if (FacebookLinked != null)
                FacebookLinked(this, e);
        }


        public delegate void FacebookUnLinkedEventHandler(object sender, EventArgs e);
        public event FacebookUnLinkedEventHandler FacebookUnLinked;
        public virtual void OnFacebookUnLinked(EventArgs e)
        {
            if (FacebookUnLinked != null)
                FacebookUnLinked(this, e);
        }


        /// <summary>
        /// 
        /// </summary>
        public ICommand LoginCommand
        {
            get
            {
                return this.loginCommand;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public ICommand LogoutCommand
        {
            get
            {
                return this.logoutCommand;
            }
        }


        public ICommand UpdateCommand
        {
            get
            {
                return this.UpdateCommand;
            }
        }


        private string _username;
        public string UserName { 
            get { return _username; } 
            set {
                if (_username != value)
                {
                    _username = value; NotifyPropertyChanged("UserName");
                };
            } 
        }
        
        private string _name;
        /// <summary>
        /// Имя пользователя
        /// </summary>
        public string Name { 
            get { return _name; } 
            set { 
                _name = value; 
                NotifyPropertyChanged("Name"); 
            } 
        }

        private string _secondName;
        /// <summary>
        /// Фамилия пользователя
        /// </summary>
        public string SecondName { get { return _secondName; } set { _secondName = value; NotifyPropertyChanged("SecondName"); } }

        private string _birthday;
        public string Birthday
        {
            get
            {
                return _birthday;
            }
            set
            {
                _birthday = value;
                try
                {
                    if (_birthday != "")
                    {
                        DateBirthday = DateTime.Parse(_birthday.ToString());
                    }
                    else
                    {
                        DateBirthday = DateTime.Today;
                        _birthday = DateBirthday.ToShortDateString();
                    };

                }
                catch { };
                NotifyPropertyChanged("Birthday");
            }
        }

        private DateTime _dateBirthday = DateTime.Today;
        public DateTime DateBirthday
        {
            get
            {
                return _dateBirthday;
            }
            set
            {
                _dateBirthday = value;
                _birthday = DateBirthday.ToShortDateString();
                NotifyPropertyChanged("Birthday");
                NotifyPropertyChanged("DateBirthday");
            }
        }

        public void NotifyAll()
        {
            try
            {
                ClassToUser();

                NotifyPropertyChanged("Name");
                NotifyPropertyChanged("UserName");
                NotifyPropertyChanged("Birthday");
                NotifyPropertyChanged("DateBirthday");
                NotifyPropertyChanged("OutBloodGroup");
                NotifyPropertyChanged("OutBloodRh");
                NotifyPropertyChanged("NearestBloodGive");
                NotifyPropertyChanged("OutBloodDataString");
                NotifyPropertyChanged("OutSex");
                NotifyPropertyChanged("GivedBlood");
            }
            catch { };
        }

        public void ClassToUser()
        {
            try
            {
                this.UserLoading = ViewModelLocator.MainStatic.User.UserLoading;
                this.UserName = ViewModelLocator.MainStatic.User.UserName;
                this.Name = ViewModelLocator.MainStatic.User.Name;
                this.SecondName = ViewModelLocator.MainStatic.User.SecondName;
                this.Sex = ViewModelLocator.MainStatic.User.Sex;
                this.sessionToken = ViewModelLocator.MainStatic.User.sessionToken;
                this.objectId = ViewModelLocator.MainStatic.User.objectId;
                this.Birthday = ViewModelLocator.MainStatic.User.Birthday;
                this.BloodGroup = ViewModelLocator.MainStatic.User.BloodGroup;
                this.BloodRh = ViewModelLocator.MainStatic.User.BloodRh;
                this.CreatedAt = ViewModelLocator.MainStatic.User.CreatedAt;
                this.DateBirthday = ViewModelLocator.MainStatic.User.DateBirthday;
                this.FacebookId = ViewModelLocator.MainStatic.User.FacebookId;
                this.GivedBlood = ViewModelLocator.MainStatic.User.GivedBlood;
                this.IsFacebookLoggedIn = ViewModelLocator.MainStatic.User.IsFacebookLoggedIn;
                this.IsLoggedIn = ViewModelLocator.MainStatic.User.IsLoggedIn;
                //this.Password = ViewModelLocator.MainStatic.User.Password;
            } catch {};
        }

        public void UserToClass()
        {
            try
            {
                ViewModelLocator.MainStatic.User.UserLoading = this.UserLoading;
                ViewModelLocator.MainStatic.User.UserName = this.UserName;
                ViewModelLocator.MainStatic.User.Name = this.Name;
                ViewModelLocator.MainStatic.User.SecondName = this.SecondName;
                ViewModelLocator.MainStatic.User.Sex = this.Sex;
                ViewModelLocator.MainStatic.User.sessionToken = this.sessionToken;
                ViewModelLocator.MainStatic.User.objectId = this.objectId;
                ViewModelLocator.MainStatic.User.Birthday = this.Birthday;
                ViewModelLocator.MainStatic.User.BloodGroup = this.BloodGroup;
                ViewModelLocator.MainStatic.User.BloodRh = this.BloodRh;
                ViewModelLocator.MainStatic.User.CreatedAt = this.CreatedAt;
                ViewModelLocator.MainStatic.User.DateBirthday = this.DateBirthday;
                ViewModelLocator.MainStatic.User.FacebookId = this.FacebookId;
                ViewModelLocator.MainStatic.User.GivedBlood = this.GivedBlood;
                ViewModelLocator.MainStatic.User.IsFacebookLoggedIn = this.IsFacebookLoggedIn;
                ViewModelLocator.MainStatic.User.IsLoggedIn = this.IsLoggedIn;
                //ViewModelLocator.MainStatic.User.Password = this.Password;
            }
            catch { };
        }

        public void RestoreUserPassword(string email) {
            try
            {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/requestPasswordReset", Method.POST);
                request.AddHeader("Accept", "application/json");
                request.Parameters.Clear();
                string strJSONContent = "{\"email\":\"" + email.ToLower() + "\"}";
                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                request.AddHeader("Content-Type", "application/json");

                request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);
                this.UserLoading = true;
                client.ExecuteAsync(request, response =>
                {
                    this.UserLoading = false;
                    JObject o = JObject.Parse(response.Content.ToString());
                    if (o["error"] == null)
                    {
                        MessageBox.Show(Donor.AppResources.RestoreEmailSend);
                        FlurryWP7SDK.Api.LogEvent("User_restore_password");
                    }
                    else
                    {
                        MessageBox.Show(Donor.AppResources.RestoreEmailProblem);
                    };
                });
            }
            catch { };
        }


        private string _password;
        public string Password { 
            get { return _password; } 
            set {
                if (_password!=value)
                {
                    _password = value; NotifyPropertyChanged("Password"); 
                };
            } 
        }


        public DateTime? UpdatedAt { get; set; }
        public DateTime? CreatedAt { get; set; }

        private string _facebookId;
        public string FacebookId { 
            get { return _facebookId; } 
            set { 
                _facebookId = value; 
                NotifyPropertyChanged("FacebookId");
                NotifyPropertyChanged("IsFacebookLoggedIn"); 
            } 
        }

        private string _facebookToken;
        public string FacebookToken
        {
            get { return _facebookToken; }
            set
            {
                _facebookToken = value;
                NotifyPropertyChanged("FacebookToken");
                NotifyPropertyChanged("IsFacebookLoggedIn");
            }
        }

        public bool IsFacebookLoggedIn {
        get {
            if ((_facebookId != "") || (_facebookId != null))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        private set{
        }
        }

        private bool _isLoggedIn = false;
        public bool IsLoggedIn { 
            get { 
                return _isLoggedIn; 
            } 
            set {
                _isLoggedIn = value;

                NotifyPropertyChanged("IsLoggedIn");
                NotifyPropertyChanged("GivedBlood");
                NotifyPropertyChanged("Sex");
                NotifyPropertyChanged("OutSex");
                NotifyPropertyChanged("OutBloodDataString"); 
            } 
        }

        public string objectId {get;set;}
        public string sessionToken {get;set;}

        private int _bloodGroup = 0;
        public int BloodGroup { 
            get { return _bloodGroup; } 
            set { 
                _bloodGroup = value; 
                NotifyPropertyChanged("BloodGroup");
                NotifyPropertyChanged("OutBloodGroup");
                NotifyPropertyChanged("OutBloodDataString"); 
            } 
        }

        private int _bloodRh = 0;
        public int BloodRh { get { return _bloodRh; } 
            set { 
                _bloodRh = value; 
                NotifyPropertyChanged("BloodRh");
                NotifyPropertyChanged("OutBloodRh");
                NotifyPropertyChanged("OutBloodDataString"); 
            } 
        }

        private int _sex = 0;
        public int Sex { get { return _sex; } set { _sex = value; NotifyPropertyChanged("Sex"); NotifyPropertyChanged("OutSex"); } }

        public int GivedBlood
        {
            private set { }
            get
            {
                int gived = 0;
                gived = (from item in ViewModelLocator.MainStatic.Events.UserItems
                         where item.Type == "1" && item.Finished==true
                        select item).Count();
                return gived;
            }
        }

        public string OutSex { private set { }
            get {
                string outstr = Donor.AppResources.DontSelected;
                switch (this.Sex)
                {
                    case 0:
                        outstr = Donor.AppResources.Male;
                        break;
                    case 1:
                        outstr = Donor.AppResources.Female;
                        break;
                    default:
                        outstr = Donor.AppResources.DontSelected;
                        break;
                }
                return outstr;
            }
        }

        public string OutBloodDataString
        {
            private set
            {
            }
            get
            {
                return this.OutBloodGroup + " " + this.OutBloodRh;
            }
        }

        public string NearestBloodGive {
            private set
            {
            }
            get
            {
                try
                {
                    return ViewModelLocator.MainStatic.Events.UserItems.OrderBy(c => c.Date).FirstOrDefault(c=>(c.Type=="1") && (c.Date > DateTime.Now)).ShortDate.ToString();
                }
                catch
                {
                    return Donor.AppResources.DontExists;
                }
            }
        }

        public string OutBloodRh
        {
            private set { }
            get
            {
                string outstr = "";
                switch (this.BloodRh)
                {                
                    case 0:
                        outstr = "RH+";
                        break;
                    case 1:
                        outstr = "RH-";
                        break;
                    default:
                        outstr = "";
                        break;
                }
                return outstr;
            }
        }

        public string OutBloodGroup
        {
            private set { }
            get
            {
                string outstr = Donor.AppResources.DontSelected2;
                switch (this.BloodGroup)
                {
                    // (0 – I, 1 – II, 2 – III, 3 – IV)                    
                    case 0:
                        outstr = Donor.AppResources.FirrstBloodGroup;
                        break;
                    case 1:
                        outstr = Donor.AppResources.SecondBloodGroup;
                        break;
                    case 2:
                        outstr = Donor.AppResources.ThirdBloodGroup;
                        break;
                    case 3:
                        outstr = Donor.AppResources.ForthBloodGroup;
                        break;
                    default:
                        outstr = Donor.AppResources.DontSelected2;
                        break;
                }
                return outstr;
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


        public void FacebookLogin(string id, string accessToken, IDictionary<string, object> result = null)
        {
            try
            {
                ViewModelLocator.MainStatic.User.UserLoading = true;
                //BadgesViewModel.PostAchieve();

                var bw = new BackgroundWorker();
                bw.DoWork += delegate
                {
                    string emailIn = "";
                    try
                    {
                        if (result != null)
                        {
                            emailIn = result["email"].ToString().ToLower();
                        };
                    }
                    catch { };
                    bool changed = false;
                    //check is exist user with such email
                    var clientCheck = new RestClient("https://api.parse.com");
                    var requestCheck = new RestRequest("1/users?where={\"username\":\"" + emailIn + "\"}", Method.GET);
                    requestCheck.Parameters.Clear();
                    requestCheck.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                    requestCheck.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                    clientCheck.ExecuteAsync(requestCheck, responseCheck =>
                    {
                        try
                        {
                            JObject o2 = JObject.Parse(responseCheck.Content.ToString());
                            if (o2["error"] == null)
                            {
                                int userscount = 0;
                                foreach (JObject item in o2["results"])
                                {
                                    userscount++;
                                };
                                var client = new RestClient("https://api.parse.com");
                                var request = new RestRequest("1/users", Method.POST);
                                request.AddHeader("Accept", "application/json");
                                request.Parameters.Clear();

                                string strJSONContent = "{\"authData\": { \"facebook\":{ \"id\": \"" + id + "\", \"access_token\": \"" + accessToken + "\", \"expiration_date\": \"" + DateTime.Now.AddMonths(1).ToString("s") + "\"  }  } }";
                                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                                if (ViewModelLocator.MainStatic.User.sessionToken != "" && ViewModelLocator.MainStatic.User.sessionToken != null)
                                {
                                    request.AddHeader("X-Parse-Session-Token", ViewModelLocator.MainStatic.User.sessionToken);
                                };
                                request.AddHeader("Content-Type", "application/json");

                                request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

                                string oldname = ViewModelLocator.MainStatic.User.Name;
                                string oldsecondname = ViewModelLocator.MainStatic.User.SecondName;
                                int oldsex = ViewModelLocator.MainStatic.User.Sex;

                                client.ExecuteAsync(request, response =>
                                {
                                    //try
                                    //{
                                    JObject o = JObject.Parse(response.Content.ToString());
                                    if (o["error"] == null)
                                    {
                                        if ((response.StatusCode!=HttpStatusCode.Created) || (userscount==0)) //((userscount == 0)) // || (o["username"].ToString().ToLower() == result["email"].ToString().ToLower())
                                        {
                                            BadgesViewModel.PostAchieve(id, accessToken);

                                            Deployment.Current.Dispatcher.BeginInvoke(() =>
                                            {
                                                ViewModelLocator.MainStatic.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                                                ClassToUser();

                                                try
                                                {
                                                    try
                                                    {
                                                        if ((ViewModelLocator.MainStatic.User.Name == "") || (ViewModelLocator.MainStatic.User.Name == null) || (response.StatusCode == HttpStatusCode.Created))
                                                        {
                                                            ViewModelLocator.MainStatic.User.Name = (string)result["first_name"];
                                                            changed = true;
                                                        };
                                                    }
                                                    catch
                                                    {
                                                        ViewModelLocator.MainStatic.User.Name = oldname;
                                                    };

                                                    try
                                                    {
                                                        if ((ViewModelLocator.MainStatic.User.SecondName == "") || (ViewModelLocator.MainStatic.User.SecondName == null) || (response.StatusCode == HttpStatusCode.Created))
                                                        {
                                                            ViewModelLocator.MainStatic.User.SecondName = (string)result["last_name"];
                                                            changed = true;
                                                        };
                                                    }
                                                    catch
                                                    {
                                                        ViewModelLocator.MainStatic.User.SecondName = oldsecondname;
                                                    };
                                                }
                                                catch { };

                                                try
                                                {
                                                    string temp_gender = "";
                                                    try
                                                    {
                                                        temp_gender = o["Sex"].ToString();
                                                    }
                                                    catch { };
                                                    if (temp_gender == "")
                                                    {
                                                        if ((string)result["gender"] == "male")
                                                        {
                                                            ViewModelLocator.MainStatic.User.Sex = 0;
                                                            changed = true;
                                                        };
                                                        if ((string)result["gender"] == "female")
                                                        {
                                                            ViewModelLocator.MainStatic.User.Sex = 1;
                                                            changed = true;
                                                        };
                                                    };
                                                }
                                                catch
                                                {
                                                    ViewModelLocator.MainStatic.User.Sex = oldsex;
                                                };

                                                try
                                                {
                                                    /*string temp_username = "";
                                                    try
                                                    {
                                                        temp_username = o["createdAt"].ToString();
                                                    }
                                                    catch { };*/
                                                    if ((response.StatusCode == HttpStatusCode.Created))
                                                    {
                                                        ViewModelLocator.MainStatic.User.UserName = (string)result["email"];
                                                        changed = true;
                                                    };
                                                }
                                                catch { };

                                                try
                                                {
                                                    string temp_birthday = "";
                                                    try
                                                    {
                                                        temp_birthday = o["birthday"].ToString();
                                                    }
                                                    catch { };
                                                    if ((temp_birthday == "") || (response.StatusCode == HttpStatusCode.Created))
                                                    {
                                                        string birthday = (string)result["birthday"];
                                                        CultureInfo provider = CultureInfo.InvariantCulture;
                                                        ViewModelLocator.MainStatic.User.DateBirthday = DateTime.ParseExact(birthday, "d", provider);
                                                        changed = true;
                                                    };
                                                }
                                                catch { };

                                                ViewModelLocator.MainStatic.User.IsLoggedIn = true;
                                                this.IsLoggedIn = true;
                                                ClassToUser();

                                                ViewModelLocator.MainStatic.SaveUserToStorage();

                                                ViewModelLocator.MainStatic.Events.WeekItemsUpdated();
                                                ViewModelLocator.MainStatic.Events.LoadEventsParse();

                                                ViewModelLocator.MainStatic.User.FacebookId = id;
                                                ViewModelLocator.MainStatic.User.FacebookToken = accessToken;

                                                ViewModelLocator.MainStatic.SaveUserToStorage();

                                                ViewModelLocator.MainStatic.User.NotifyAll();
                                                this.NotifyAll();

                                                ViewModelLocator.MainStatic.OnUserEnter(EventArgs.Empty);

                                                if (changed == true)
                                                {
                                                    this.UpdateAction(1);
                                                };
                                                ViewModelLocator.MainStatic.User.UserLoading = false;
                                            });
                                        }
                                        else
                                        {
                                            if (userscount > 0)
                                            {
                                                var clientDelete = new RestClient("https://api.parse.com");
                                                var requestDelete = new RestRequest("1/users/" + o["objectId"].ToString(), Method.DELETE);
                                                requestDelete.AddHeader("Accept", "application/json");
                                                requestDelete.Parameters.Clear();

                                                requestDelete.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                                                requestDelete.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                                                requestDelete.AddHeader("X-Parse-Session-Token", o["sessionToken"].ToString());

                                                clientDelete.ExecuteAsync(requestDelete, responseDelete =>
                                                {
                                                    string test = responseDelete.Content.ToString();
                                                });

                                                Deployment.Current.Dispatcher.BeginInvoke(() =>
                                                {
                                                    ViewModelLocator.MainStatic.User.IsLoggedIn = false;
                                                    ViewModelLocator.MainStatic.User.UserLoading = false;
                                                    MessageBox.Show("Похоже такой пользователь уже есть. Введите пароль, чтобы привязать профиль.");
                                                    try
                                                    {
                                                        (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/ProfileLogin.xaml?task=login&email=" + result["email"].ToString().ToLower(), UriKind.Relative));
                                                    }
                                                    catch { };
                                                    ViewModelLocator.MainStatic.User.UserLoading = false;
                                                });
                                            };
                                        };
                                    }
                                    else
                                    {
                                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                                        {
                                            ViewModelLocator.MainStatic.User.IsLoggedIn = false;
                                            MessageBox.Show(Donor.AppResources.UncorrectLoginData);
                                            ViewModelLocator.MainStatic.User.NotifyAll();
                                            this.NotifyAll();
                                            ViewModelLocator.MainStatic.User.UserLoading = false;
                                        });
                                    };
                                    

                                });

                                //};
                            }
                            else
                            {
                            };
                        }
                        catch
                        {
                            Deployment.Current.Dispatcher.BeginInvoke(() =>
                                    {
                                        ViewModelLocator.MainStatic.User.UserLoading = false;
                                    });
                        };
                    });
                };
                bw.RunWorkerAsync();
            }
            catch { };
            ////////////////////////////////////////
        }

        public void FacebookLinking(string id, string accessToken)
        {
            try
            {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/users/" + ViewModelLocator.MainStatic.User.objectId, Method.PUT);
                request.AddHeader("Accept", "application/json");
                request.Parameters.Clear();

                string strJSONContent = "{\"authData\": { \"facebook\":{ \"id\": \"" + id + "\", \"access_token\": \"" + accessToken + "\", \"expiration_date\": \"" + DateTime.Now.AddMonths(1).ToString("s") + "\"  }  } }";
                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                request.AddHeader("X-Parse-Session-Token", ViewModelLocator.MainStatic.User.sessionToken);
                request.AddHeader("Content-Type", "application/json");

                request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

                client.ExecuteAsync(request, response =>
                {
                    try
                    {
                        JObject o = JObject.Parse(response.Content.ToString());
                        if (o["error"] == null)
                        {
                            BadgesViewModel.PostAchieve(id, accessToken);
                            MessageBox.Show("Выполнена привязка.");

                            ViewModelLocator.MainStatic.SaveUserToStorage();

                            this.UpdateAction(null);

                            FlurryWP7SDK.Api.LogEvent("Facebook_linking");

                            this.FacebookLinked(this, EventArgs.Empty);
                        }
                        else
                        {
                            //Another user is already linked to this facebook id.
                            if (o["code"].ToString() == "208")
                            {
                                MessageBox.Show("Не удалось привязать профиль, т.к. он привязан к другому аккаунту.");
                            }
                            else
                            {
                                MessageBox.Show("Не удалось выполнить привязку.");
                            };

                            ViewModelLocator.MainStatic.User.FacebookId = "";
                            ViewModelLocator.MainStatic.User.FacebookToken = "";
                            ViewModelLocator.MainStatic.SaveUserToStorage();
                            //this.UpdateAction(null);

                            this.FacebookUnLinked(this, EventArgs.Empty);
                        };
                    }
                    catch { };
                });
            }
            catch { };
        }

        //public Visibility FacebookLinkingButtonVisible = Visibility.Visible;
        //public Visibility FacebookUnlinkingButtonVisible = Visibility.Collapsed;

        public void FacebookUnlinking()
        {
            try
            {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/users/" + ViewModelLocator.MainStatic.User.objectId, Method.PUT);
                request.AddHeader("Accept", "application/json");
                request.Parameters.Clear();

                string strJSONContent = "{\"authData\": { \"facebook\": null } }";
                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                request.AddHeader("X-Parse-Session-Token", ViewModelLocator.MainStatic.User.sessionToken);
                request.AddHeader("Content-Type", "application/json");

                request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

                client.ExecuteAsync(request, response =>
                {
                    try
                    {
                        JObject o = JObject.Parse(response.Content.ToString());

                        if (o["error"] == null)
                        {
                            MessageBox.Show(Donor.AppResources.FacebookUnlinkedMessage);

                            ViewModelLocator.MainStatic.User.FacebookId = "";
                            ViewModelLocator.MainStatic.User.FacebookToken = "";

                            ViewModelLocator.MainStatic.SaveUserToStorage();

                            FlurryWP7SDK.Api.LogEvent("Facebook_unlinking");
                            this.FacebookUnLinked(this, EventArgs.Empty);
                        }
                        else
                        {
                            MessageBox.Show("Не удалось отзвять профиль facebook.");
                            this.FacebookLinked(this, EventArgs.Empty);
                        };
                    }
                    catch { };
                });
            }
            catch { };
        }

    };
}
