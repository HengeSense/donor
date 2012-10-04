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
        }
        private string _username;
        public string UserName { get { return _username; } set { _username = value; NotifyPropertyChanged("UserName"); } }
        private string _name;
        public string Name { get { return _name; } set { _name = value; NotifyPropertyChanged("Name"); } }
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
                NotifyPropertyChanged("IsLoggedIn"); 
            } 
        }

        public string objectId {get;set;}
        public string sessionToken {get;set;}

        public int BloodGroup { get; set; }
        public int BloodRh { get; set; }
        public int Sex { get; set; }

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
                string outstr = "не выбран";
                switch (this.Sex)
                {
                    case 0:
                        outstr = "Мужской";
                        break;
                    case 1:
                        outstr = "Женский";
                        break;
                    default:
                        outstr = "не выбран";
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
                    return "отсутствует";
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
                string outstr = "не выбрано";
                switch (this.BloodGroup)
                {
                    // (0 – I, 1 – II, 2 – III, 3 – IV)                    
                    case 0:
                        outstr = "O(I)";
                        break;
                    case 1:
                        outstr = "A(II)";
                        break;
                    case 2:
                        outstr = "B(III)";
                        break;
                    case 3:
                        outstr = "AB(IV)";
                        break;
                    default:
                        outstr = "не выбрано";
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
    };
}
