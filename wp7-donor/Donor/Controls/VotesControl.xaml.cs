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

namespace Donor.Controls
{
    public partial class VotesControl : UserControl
    {
        public int Vote { get; set; }

        public VotesControl()
        {
            InitializeComponent();

            this.Vote = 0;
        }

        ImageSource opacity_on = new BitmapImage(new Uri("/Donor;component/images/ic_star_act.png", UriKind.Relative));
        ImageSource opacity_off = new BitmapImage(new Uri("/Donor;component/images/ic_star_pas.png", UriKind.Relative));

        private void Star1_Tap(object sender, GestureEventArgs e)
        {

            this.Star1.Source = opacity_on;
            this.Star2.Source = opacity_off;
            this.Star3.Source = opacity_off;
            this.Star4.Source = opacity_off;
            this.Star5.Source = opacity_off;

            this.Vote = 1;
        }

        private void Star2_Tap(object sender, GestureEventArgs e)
        {
            this.Star1.Source = opacity_on;
            this.Star2.Source = opacity_on;
            this.Star3.Source = opacity_off;
            this.Star4.Source = opacity_off;
            this.Star5.Source = opacity_off;

            this.Vote = 2;
        }

        private void Star3_Tap(object sender, GestureEventArgs e)
        {
            this.Star1.Source = opacity_on;
            this.Star2.Source = opacity_on;
            this.Star3.Source = opacity_on;
            this.Star4.Source = opacity_off;
            this.Star5.Source = opacity_off;

            this.Vote = 3;
        }

        private void Star4_Tap(object sender, GestureEventArgs e)
        {
            this.Star1.Source = opacity_on;
            this.Star2.Source = opacity_on;
            this.Star3.Source = opacity_on;
            this.Star4.Source = opacity_on;
            this.Star5.Source = opacity_off;

            this.Vote = 4;
        }

        private void Star5_Tap(object sender, GestureEventArgs e)
        {
            this.Star1.Source = opacity_on;
            this.Star2.Source = opacity_on;
            this.Star3.Source = opacity_on;
            this.Star4.Source = opacity_on;
            this.Star5.Source = opacity_on;

            this.Vote = 5;
        }
    }
}
