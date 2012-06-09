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
//using Parse;

namespace Donor.ViewModels
{
    public class UserViewModel
    {

    }

    //could also implement IParseObject (in addition to IParseUser)
    public class DonorUser: INotifyPropertyChanged
    {
        public DonorUser()
        {
            this.IsLoggedIn = false;
        }
        private string _objectid;
        public string ObjectId { get { return _objectid; } set { _objectid = value; NotifyPropertyChanged("ObjectId"); } }
        private string _username;
        public string UserName { get { return _username; } set { _username = value; NotifyPropertyChanged("UserName"); } }
        private string _name;
        public string Name { get { return _name; } set { _name = value; NotifyPropertyChanged("Name"); } }
        private string _password;
        public string Password { get { return _password; } set { _password = value; NotifyPropertyChanged("Password"); } }

        public DateTime? UpdatedAt { get; set; }
        public DateTime? CreatedAt { get; set; }

        private bool _isLoggedIn = false;
        public bool IsLoggedIn { 
            get { 
                return _isLoggedIn; 
            } 
            set { 
                _isLoggedIn = value; NotifyPropertyChanged("IsLoggedIn"); 
            } 
        }

        public string objectId {get;set;}
        public string sessionToken {get;set;}

        public string BloodGroup { get; set; }
        public string BloodRh { get; set; }
        public string Sex { get; set; }

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
