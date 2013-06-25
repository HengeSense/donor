using DonorAppW8.ViewModel.Contras;
//using DonorAppW8.Data;
using DonorAppW8.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;

namespace DonorAppW8
{
    class MyDataTemplateSelector : DataTemplateSelector
    {

        public DataTemplate Template1 { get; set; }
        public DataTemplate Template2 { get; set; }
        public DataTemplate Template3 { get; set; }
        public DataTemplate Template4 { get; set; }
        //NewsItemTemplate

        protected override DataTemplate SelectTemplateCore(object item, DependencyObject container)
        {
            try
            {
                //NewsViewModel dataItem = item as NewsViewModel;
                if (item.GetType() == typeof(AdsViewModel))
                {
                    return Template2;
                };
                if (item.GetType() == typeof(YAStationItem))
                {
                    return Template3;
                };
                if (item.GetType() == typeof(ContraViewModel))
                {
                    return Template4;
                };
                /*if (dataItem.Group.UniqueId.Contains("MainNews") || dataItem.Group.UniqueId.Contains("Tourist"))
                //dataItem.Group.UniqueId.Contains("http://rybinsk.ru/news-2013?format=feed") || 
                {
                    return Template1;
                }
                else
                {
                    return Template2;
                };*/
                return Template1;
            }
            catch {
                return Template2;
            };
        }
    }
}
