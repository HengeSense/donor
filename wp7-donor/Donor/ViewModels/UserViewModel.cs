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
//using Parse;

namespace Donor.ViewModels
{
    public class UserViewModel
    {

    }

    //could also implement IParseObject (in addition to IParseUser)
    public class DonorUser//: IUser
    {
        public string Id { get; set; }
        public string UserName { get; set; }
        public string Password {get;set;}

        public DateTime? UpdatedAt { get; set; }
        public DateTime? CreatedAt { get; set; }
        //any other properties specific to your app here
    };
}
