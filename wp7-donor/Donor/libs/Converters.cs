using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Data;

namespace Donor
{
    public class StringConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter,
                       CultureInfo culture)
        {
            if (value != null && value is string)
            {
                var bValue = (string)value;
                //var visibility = (Visibility)Enum.Parse(typeof(Visibility), parameter.ToString(), true);
                if (bValue != "") {
                    return Visibility.Visible;
                } else {
                    return Visibility.Collapsed;
                };
                /*return visibility ==
                   Visibility.Visible ? Visibility.Collapsed : Visibility.Visible;*/
            }
            return Visibility.Collapsed;
            //return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter,
                           CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
