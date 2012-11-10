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
            this.Password = "";
            this.NotifyAll();

            //App.ViewModel.User = new DonorUser();

            App.ViewModel.User.UserName = "";
            App.ViewModel.User.Password = "";
            this.NotifyAll();

            App.ViewModel.SaveUserToStorage();

            App.ViewModel.Events.UpdateItems();

            

            (Application.Current.RootVisual as PhoneApplicationFrame).GoBack();
        }

        /// <summary>
        /// Обновление данных профиля пользователя на parse.com
        /// </summary>
        /// <param name="p"></param>
        public void UpdateAction(object p)
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/users/" + this.objectId.ToString(), Method.PUT);
            request.AddHeader("Accept", "application/json");
            request.Parameters.Clear();
            string strJSONContent = "{\"Sex\":" + this.Sex + ", \"Name\":\"" + this.Name + "\", \"secondName\":\"" + this.SecondName + "\", \"birthday\": \"" + this.Birthday + "\", \"BloodGroup\":" + this.BloodGroup + ", \"BloodRh\":" + this.BloodRh + "}";
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
            request.AddHeader("X-Parse-Session-Token", App.ViewModel.User.sessionToken);
            request.AddHeader("Content-Type", "application/json");
            request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

            this.UserLoading = true;

            client.ExecuteAsync(request, response =>
            {
                this.UserLoading = false;
                try
                {
                    JObject o = JObject.Parse(response.Content.ToString());
                    if (o["error"] == null)
                    {
                        MessageBox.Show("Данные профиля обновлены.");
                    }
                    else
                    {
                        //MessageBox.Show(response.Content.ToString());
                    };
                    ClassToUser();
                }
                catch
                {
                };
            });
        }


        public void LoginAction(object p)
        {
            //try
            //{
                App.ViewModel.User.UserLoading = true;

                string passwordCurrent = this.Password;

                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/login?username=" + Uri.EscapeUriString(this.UserName.ToLower()) + "&password=" + Uri.EscapeUriString(this.Password), Method.GET);
                request.Parameters.Clear();
                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

                App.ViewModel.User.IsLoggedIn = false;                

                client.ExecuteAsync(request, response =>
                {
                    try
                    {
                        JObject o = JObject.Parse(response.Content.ToString());
                        if (o["error"] == null)
                        {
                            App.ViewModel.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                            ClassToUser();

                            App.ViewModel.User.IsLoggedIn = true;
                            this.IsLoggedIn = true;
                            this.Password = passwordCurrent;
                            App.ViewModel.User.Password = passwordCurrent;

                            App.ViewModel.SaveUserToStorage();

                            App.ViewModel.Events.WeekItemsUpdated();
                            App.ViewModel.Events.LoadEventsParse();

                            App.ViewModel.SaveUserToStorage();

                            App.ViewModel.User.NotifyAll();
                            this.NotifyAll();

                            App.ViewModel.OnUserEnter(EventArgs.Empty);
                        }
                        else
                        {
                            App.ViewModel.User.IsLoggedIn = false;
                            MessageBox.Show(Donor.AppResources.UncorrectLoginData);

                            App.ViewModel.User.NotifyAll();
                            this.NotifyAll();
                        };
                        App.ViewModel.User.UserLoading = false;
                    }
                    catch {
                        App.ViewModel.User.UserLoading = false;
                    };
                });
            //}
            //catch {
            //    App.ViewModel.User.UserLoading = false;
            //};
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

        public void ClassToUser()
        {
            this.UserLoading = App.ViewModel.User.UserLoading;
            this.UserName = App.ViewModel.User.UserName;
            this.Name = App.ViewModel.User.Name;
            this.SecondName = App.ViewModel.User.SecondName;
            this.Sex = App.ViewModel.User.Sex;
            this.sessionToken = App.ViewModel.User.sessionToken;
            this.objectId = App.ViewModel.User.objectId;
            this.Birthday = App.ViewModel.User.Birthday;
            this.BloodGroup = App.ViewModel.User.BloodGroup;
            this.BloodRh = App.ViewModel.User.BloodRh;
            this.CreatedAt = App.ViewModel.User.CreatedAt;
            this.DateBirthday = App.ViewModel.User.DateBirthday;
            this.FacebookId = App.ViewModel.User.FacebookId;
            this.GivedBlood = App.ViewModel.User.GivedBlood;
            this.IsFacebookLoggedIn = App.ViewModel.User.IsFacebookLoggedIn;
            this.IsLoggedIn = App.ViewModel.User.IsLoggedIn;
            this.Password = App.ViewModel.User.Password;
        }

        public void UserToClass()
        {
            App.ViewModel.User.UserLoading = this.UserLoading;
            App.ViewModel.User.UserName = this.UserName;
            App.ViewModel.User.Name = this.Name;
            App.ViewModel.User.SecondName = this.SecondName;
            App.ViewModel.User.Sex = this.Sex;
            App.ViewModel.User.sessionToken = this.sessionToken;
            App.ViewModel.User.objectId = this.objectId;
            App.ViewModel.User.Birthday = this.Birthday;
            App.ViewModel.User.BloodGroup = this.BloodGroup;
            App.ViewModel.User.BloodRh = this.BloodRh;
            App.ViewModel.User.CreatedAt = this.CreatedAt;
            App.ViewModel.User.DateBirthday = this.DateBirthday;
            App.ViewModel.User.FacebookId = this.FacebookId;
            App.ViewModel.User.GivedBlood = this.GivedBlood;
            App.ViewModel.User.IsFacebookLoggedIn = this.IsFacebookLoggedIn;
            App.ViewModel.User.IsLoggedIn = this.IsLoggedIn;
            App.ViewModel.User.Password = this.Password;
        }

        public void RestoreUserPassword(string email) {
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
                }
                else
                {
                };
            });
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

        private string _facebookId = "";
        public string FacebookId { 
            get { return _facebookId; } 
            set { 
                _facebookId = value; 
                NotifyPropertyChanged("FacebookId");
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
                gived = (from item in App.ViewModel.Events.UserItems
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
                    return App.ViewModel.Events.UserItems.OrderBy(c => c.Date).FirstOrDefault(c=>(c.Type=="1") && (c.Date > DateTime.Now)).ShortDate.ToString();
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
        public string FacebookToken;
        private void NotifyPropertyChanged(String propertyName)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (null != handler)
            {
                handler(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        public void FacebookLinking(string id, string accessToken)
        {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/users/"+App.ViewModel.User.objectId, Method.PUT);
                request.AddHeader("Accept", "application/json");
                request.Parameters.Clear();

                string strJSONContent = "{\"authData\": { \"facebook\":{ \"id\": \"" + id + "\", \"access_token\": \"" + accessToken + "\", \"expiration_date\": \"" + DateTime.Now.AddMonths(1).ToString("s") + "\"  }  } }";
                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                request.AddHeader("X-Parse-Session-Token", App.ViewModel.User.sessionToken);
                request.AddHeader("Content-Type", "application/json");

                request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

                client.ExecuteAsync(request, response =>
                {
                    try
                    {
                        JObject o = JObject.Parse(response.Content.ToString());
                        if (o["error"] == null)
                        {
                            MessageBox.Show("Выполнен вход c использованием Facebook.");
                        }
                        else
                        {
                        };
                    }
                    catch { };
                });
        }

        public void FacebookUnlinking()
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/users/" + App.ViewModel.User.objectId, Method.PUT);
            request.AddHeader("Accept", "application/json");
            request.Parameters.Clear();

            string strJSONContent = "{\"authData\": { \"facebook\": null } }";
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
            request.AddHeader("X-Parse-Session-Token", App.ViewModel.User.sessionToken);
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
                    }
                    else
                    {
                    };
                }
                catch { };
            });
        }

    };
}
