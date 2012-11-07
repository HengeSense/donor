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
            this.logoutCommand = new DelegateCommand(this.LogoutAction);
        }

        private ICommand loginCommand;
        private ICommand logoutCommand;

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


        private void LogoutAction(object p)
        {
            this.IsLoggedIn = false;
            this.UserName = "";
            this.Password = "";

            App.ViewModel.SaveUserToStorage();
            App.ViewModel.Events.UpdateItems();

            this.NotifyAll();

            (Application.Current.RootVisual as PhoneApplicationFrame).GoBack();
            //NavigationService.GoBack();
        }


        private void LoginAction(object p)
        {
            try
            {
                UserLoading = true;

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
                            App.ViewModel.User.IsLoggedIn = true;
                            App.ViewModel.User.Password = passwordCurrent;

                            App.ViewModel.SaveUserToStorage();

                            App.ViewModel.Events.WeekItemsUpdated();
                            App.ViewModel.Events.LoadEventsParse();

                            App.ViewModel.OnUserEnter(EventArgs.Empty);
                        }
                        else
                        {
                            App.ViewModel.User.IsLoggedIn = false;
                            MessageBox.Show(Donor.AppResources.UncorrectLoginData);
                        };
                        UserLoading = false;
                    }
                    catch {
                        UserLoading = false;
                    };
                });
            }
            catch {
                UserLoading = false;
            };
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

        private string _username;
        public string UserName { get { return _username; } set { _username = value; NotifyPropertyChanged("UserName"); } }
        
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

        private DateTime _dateBirthday;
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

        private string _password;
        public string Password { get { return _password; } set { _password = value; NotifyPropertyChanged("Password"); } }


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
                //App.ViewModel.CreateApplicationTile(App.ViewModel.Events.NearestEvents());

                /*if (_isLoggedIn == false)
                {
                    this.UserName = "";
                    this.Password = "";                 
                };*/

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
