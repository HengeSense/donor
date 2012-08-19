using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Windows.Media.Imaging;

using System.ComponentModel;

namespace Donor.Controls
{
    public partial class VotesControl : UserControl
    {

        public int Vote2 { get; set; }

        private int _vote;
        
        public int Vote {
            get {
                return _vote;
            }
            set 
            {
                try
                {
                    _vote = value;
                    switch (_vote)
                    {
                        case 1:
                            this.Star1.Source = opacity_on;
                            this.Star2.Source = opacity_off;
                            this.Star3.Source = opacity_off;
                            this.Star4.Source = opacity_off;
                            this.Star5.Source = opacity_off;
                            break;
                        case 2:
                            this.Star1.Source = opacity_on;
                            this.Star2.Source = opacity_on;
                            this.Star3.Source = opacity_off;
                            this.Star4.Source = opacity_off;
                            this.Star5.Source = opacity_off;
                            break;
                        case 3:
                            this.Star1.Source = opacity_on;
                            this.Star2.Source = opacity_on;
                            this.Star3.Source = opacity_on;
                            this.Star4.Source = opacity_off;
                            this.Star5.Source = opacity_off;
                            break;
                        case 4:
                            this.Star1.Source = opacity_on;
                            this.Star2.Source = opacity_on;
                            this.Star3.Source = opacity_on;
                            this.Star4.Source = opacity_on;
                            this.Star5.Source = opacity_off;
                            break;
                        case 5:
                            this.Star1.Source = opacity_on;
                            this.Star2.Source = opacity_on;
                            this.Star3.Source = opacity_on;
                            this.Star4.Source = opacity_on;
                            this.Star5.Source = opacity_on;
                            break;
                        default:
                            _vote = 0;
                            this.Star1.Source = opacity_off;
                            this.Star2.Source = opacity_off;
                            this.Star3.Source = opacity_off;
                            this.Star4.Source = opacity_off;
                            this.Star5.Source = opacity_off;
                            break;
                    }
                }
                catch
                {
                    _vote = 0;
                    this.Star1.Source = opacity_off;
                    this.Star2.Source = opacity_off;
                    this.Star3.Source = opacity_off;
                    this.Star4.Source = opacity_off;
                    this.Star5.Source = opacity_off;
                };
            }
        }


        public event System.ComponentModel.PropertyChangedEventHandler VoteChanged;

        public void OnemployeeNameChanged(System.ComponentModel.PropertyChangedEventArgs e)
        {
            //Raise the employeeIDChanged event.
            if (VoteChanged != null)
                VoteChanged(this, e);
        }

        public VotesControl()
        {
            InitializeComponent();

            this.Vote = 0;
        }

        ImageSource opacity_on = new BitmapImage(new Uri("/Donor;component/images/ic_star_act.png", UriKind.Relative));
        ImageSource opacity_off = new BitmapImage(new Uri("/Donor;component/images/ic_star_pas.png", UriKind.Relative));

        private void Star1_Tap(object sender, GestureEventArgs e)
        {
            this.Vote = 1;
        }

        private void Star2_Tap(object sender, GestureEventArgs e)
        {
            this.Vote = 2;
        }

        private void Star3_Tap(object sender, GestureEventArgs e)
        {
            this.Vote = 3;
        }

        private void Star4_Tap(object sender, GestureEventArgs e)
        {
            this.Vote = 4;
        }

        private void Star5_Tap(object sender, GestureEventArgs e)
        {
            this.Vote = 5;
        }
    }
}
