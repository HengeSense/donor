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
using Microsoft.Phone.Controls;
using Donor.ViewModels;
using Telerik.Windows.Data;
using Microsoft.Phone.Net.NetworkInformation;
using Telerik.Windows.Controls;

namespace Donor
{
    public partial class StationsSearch : PhoneApplicationPage
    {
        public StationsSearch()
        {
            InitializeComponent();

            //this.StationsSearchText.ItemsSource = ViewModelLocator.MainStatic.Stations.DistanceItems;
            //this.StationsSearchText.FilterMode = AutoCompleteFilterMode.Contains;
            //this.StationsSearchText.ItemFilter += SearchBank;

            //this.StationsList.GroupDescriptors.Add(GroupedBadgesList);
            this.StationsList.GroupDescriptors.Clear();
            if (ViewModelLocator.MainStatic.Stations.CurrentDistrict != "")
            {
                this.StationsList.GroupDescriptors.Add(GroupedDistrictBadgesList);
            }
            else
            {
                this.StationsList.GroupDescriptors.Add(GroupedBadgesList);
            };
            //Sort.SortMode 
            this.StationsList.SortDescriptors.Add(Sort);

            InteractionEffectManager.AllowedTypes.Add(typeof(Grid));
            //InteractionEffectManager.AllowedTypes.Add(typeof(Button));
            InteractionEffectManager.AllowedTypes.Add(typeof(StackPanel));
            InteractionEffectManager.AllowedTypes.Add(typeof(Border));
            //InteractionEffectManager.AllowedTypes.Add(typeof(Image));
            InteractionEffectManager.AllowedTypes.Add(typeof(RadJumpList));
            InteractionEffectManager.AllowedTypes.Add(typeof(RadDataBoundListBoxItem));
        }

        public GenericGroupDescriptor<YAStationItem, string> GroupedBadgesList = new GenericGroupDescriptor<YAStationItem, string>(item => item.Region_name);
        public GenericGroupDescriptor<YAStationItem, string> GroupedDistrictBadgesList = new GenericGroupDescriptor<YAStationItem, string>(item => item.District_name);
        public GenericSortDescriptor<YAStationItem, Int32> Sort = new GenericSortDescriptor<YAStationItem, Int32>(item => Convert.ToInt32(item.Distance));

        //custom filter
        bool CustomFilter(string search, string value)
        {
            return (value.Length > 2);
        }
        bool SearchBank(string search, object value)
        {
            if (value != null)
            {
                //if ((value as StationViewModel).Title.ToString().ToLower().Contains(search)) return true;
            }
            return false;
        }

        private void StationsList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (task != "select")
                {
                    string id = ((sender as ListBox).SelectedItem as StationViewModel).Nid.ToString();
                    NavigationService.Navigate(new Uri("/StationPage.xaml?id=" + id, UriKind.Relative));
                }
                else
                {
                    ViewModelLocator.MainStatic.Stations.SelectedStation = ((sender as ListBox).SelectedItem as StationViewModel).objectId.ToString();
                    NavigationService.GoBack();
                };
            }
            catch
            {
            }
        }

        private void ShowNoResults()
        {
            /*if (this.StationsList.Items.Count() > 0)
            {
                this.Noresults.Visibility = Visibility.Collapsed;
            }
            else
            {
                this.Noresults.Visibility = Visibility.Visible;
            };*/
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            this.StationsList.GroupDescriptors.Clear();
            if (ViewModelLocator.MainStatic.Stations.CurrentDistrict != "")
            {
                this.StationsList.GroupDescriptors.Add(GroupedDistrictBadgesList);
            }
            else
            {
                this.StationsList.GroupDescriptors.Add(GroupedBadgesList);
            };

            try
            {
                if (task == "select")
                {
                    AppBar.IsVisible = false;
                }
                else
                {
                    AppBar.IsVisible = true;
                };
            }
            catch { };
            this.StationsSearchText.Text = ViewModelLocator.MainStatic.Stations.FilteredText;

            //this.StationsList.DataContext = ViewModelLocator.MainStatic;
            if (ViewModelLocator.MainStatic.Stations.IsFilter == false)
            {
                if (ViewModelLocator.MainStatic.Stations.FilteredText == "")
                {
                    this.StationsList.ItemsSource = ViewModelLocator.MainStatic.Stations.DistanceItems;
                }
                else
                {
                    this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.DistanceItems
                                                    where (stations.Name.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower()) || stations.Address.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower()))
                                                    orderby stations.Distance ascending
                                                    select stations;
                };
            }
            else
            {
                if (ViewModelLocator.MainStatic.Stations.FilteredText == "")
                {
                    this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.DistanceItems
                                                    where (stations.Town == ViewModelLocator.MainStatic.Stations.SelectedCity)
                                                    && (((!ViewModelLocator.MainStatic.Stations.IsChildrenDonor)) && ((!ViewModelLocator.MainStatic.Stations.IsRegional)) && ((!ViewModelLocator.MainStatic.Stations.IsSaturdayWork)))
                                                    orderby stations.Distance ascending
                                                    select stations;
                }
                else
                {
                    this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.DistanceItems
                                                    where (stations.Name == ViewModelLocator.MainStatic.Stations.SelectedCity)
                                                    && (stations.Name.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower())) && ((stations.Address.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower()) || stations.Address.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower())))
                                                    orderby stations.Distance ascending
                                                    select stations;
                };
            };
            ShowNoResults();
        }

        protected override void OnNavigatedFrom(System.Windows.Navigation.NavigationEventArgs e)
        {
            string searchtext = this.StationsSearchText.Text;
            ViewModelLocator.MainStatic.Stations.FilteredText = searchtext;
            base.OnNavigatedFrom(e);
        }

        private string PastSearchString = "";
        private void FilterStationsList()
        {
            string searchtext = this.StationsSearchText.Text;
            ViewModelLocator.MainStatic.Stations.FilteredText = searchtext;

            if (((PastSearchString != searchtext) && (searchtext.Length > 2)) || (searchtext == "" && PastSearchString!=""))
            {
                if (searchtext != "")
                {
                    if (ViewModelLocator.MainStatic.Stations.IsFilter == false)
                    {
                        this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.DistanceItems
                                                        where (stations.Name.ToLower().Contains(searchtext.ToLower()) || stations.Address.ToLower().Contains(searchtext.ToLower()))
                                                        orderby stations.Distance ascending
                                                        select stations;
                    }
                    else
                    {
                        this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.DistanceItems
                                                        where (stations.Name.ToLower().Contains(searchtext.ToLower())) && ((stations.Town == ViewModelLocator.MainStatic.Stations.SelectedCity)
                                                            && ((stations.Name.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower())) || stations.Address.ToLower().Contains(searchtext.ToLower())))
                                                        orderby stations.Distance ascending
                                                        select stations;
                    };
                }
                else
                {
                    this.StationsList.DataContext = ViewModelLocator.MainStatic;
                    if (ViewModelLocator.MainStatic.Stations.IsFilter == false)
                    {
                        this.StationsList.ItemsSource = ViewModelLocator.MainStatic.Stations.DistanceItems;
                    }
                    else
                    {
                        this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.DistanceItems
                                                        where ((stations.Name == ViewModelLocator.MainStatic.Stations.SelectedCity)
                                                        && ((stations.Name.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower())) || (stations.Address.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower()))))
                                                        orderby stations.Distance ascending
                                                        select stations;
                    };
                };
                PastSearchString = searchtext;
            };
        }

        private void StationsSearchText_Populating(object sender, PopulatingEventArgs e)
        {
            FilterStationsList();
        }

        private void MapButton_Click(object sender, EventArgs e)
        {
            try {
                if ((ViewModelLocator.MainStatic.Stations.CurrentDistrict != "") ||
                    (ViewModelLocator.MainStatic.Stations.CurrentState != ""))
                {
                    NavigationService.Navigate(new Uri("/MapPage.xaml", UriKind.Relative));
                }
                else
                {
                    MessageBox.Show("Не выбран район или регион.");
                };
            } catch { };
        }

        private void ApplicationBarIconButton_Click(object sender, EventArgs e)
        {
            try { NavigationService.Navigate(new Uri("/StationsSearchFilter.xaml", UriKind.Relative));} catch { };
        }

        private void StationsList_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                //string id = ((sender as ListBox).SelectedItem as StationViewModel).objectId;
                //NavigationService.Navigate(new Uri("/StationPage.xaml?id=" + id, UriKind.Relative));
                ViewModelLocator.MainStatic.Stations.CurrentStation = ((sender as ListBox).SelectedItem as YAStationItem);
                NavigationService.Navigate(new Uri("/StationPage.xaml", UriKind.Relative));
            }
            catch
            {
            }
        }

        private void StationsSearchText_Populated(object sender, PopulatedEventArgs e)
        {
            string searchtext = this.StationsSearchText.Text;
        }

        private string task; 

        private void LayoutRoot_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                this.task = this.NavigationContext.QueryString["task"];
            }
            catch { };
        }

        private void StationsSearchText_LostFocus(object sender, RoutedEventArgs e)
        {
            FilterStationsList();
        }

        private void StationsSearchText_TextChanged(object sender, RoutedEventArgs e)
        {
            FilterStationsList();
        }

        private void StationsList_ItemTap(object sender, Telerik.Windows.Controls.ListBoxItemTapEventArgs e)
        {
            try
            {
                if (task=="select") {
                    //ViewModelLocator.MainStatic.Stations.SelectedStation = ((sender as ListBox).SelectedItem as StationViewModel).Nid.ToString();
                    ViewModelLocator.MainStatic.Stations.CurrentStation = ((sender as RadJumpList).SelectedItem as YAStationItem);
                    NavigationService.GoBack();
                } else {
                    ViewModelLocator.MainStatic.Stations.CurrentStation = ((sender as RadJumpList).SelectedItem as YAStationItem);
                    NavigationService.Navigate(new Uri("/StationPage.xaml", UriKind.Relative));
                };
            }
            catch
            {
            }
        }

        private void StationsList_GroupHeaderItemTap(object sender, GroupHeaderItemTapEventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/StationsSearchFilter.xaml", UriKind.Relative));
            }
            catch { };
        }

    }
}