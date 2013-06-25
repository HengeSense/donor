﻿//using DonorAppW8.Data;

using Bing.Maps;
using Callisto.Controls;
using DonorAppW8.Controls;
using DonorAppW8.ViewModel;
using DonorAppW8.ViewModels;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

// Шаблон элемента страницы сведений о группе задокументирован по адресу http://go.microsoft.com/fwlink/?LinkId=234229

namespace DonorAppW8
{
    /// <summary>
    /// Страница, на которой показываются общие сведения об отдельной группе, включая предварительный просмотр элементов
    /// внутри группы.
    /// </summary>
    public sealed partial class StationsGroupDetailPage : DonorAppW8.Common.LayoutAwarePage
    {
        public StationsGroupDetailPage()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Заполняет страницу содержимым, передаваемым в процессе навигации. Также предоставляется любое сохраненное состояние
        /// при повторном создании страницы из предыдущего сеанса.
        /// </summary>
        /// <param name="navigationParameter">Значение параметра, передаваемое
        /// <see cref="Frame.Navigate(Type, Object)"/> при первоначальном запросе этой страницы.
        /// </param>
        /// <param name="pageState">Словарь состояния, сохраненного данной страницей в ходе предыдущего
        /// сеанса. Это значение будет равно NULL при первом посещении страницы.</param>
        protected override void LoadState(Object navigationParameter, Dictionary<String, Object> pageState)
        {
            // TODO: Создание соответствующей модели данных для области проблемы, чтобы заменить пример данных
            //var group = ViewModelLocator.MainStatic..GetGroup((String)navigationParameter);
            var group = ViewModelLocator.MainStatic.Groups.FirstOrDefault(c => c.UniqueId ==(String)navigationParameter);
            this.DefaultViewModel["Group"] = group;
            this.DefaultViewModel["Items"] = ViewModelLocator.MainStatic.Stations.CurrentItems;

            ObservableCollection<YAStationItem> mapsdata = new ObservableCollection<YAStationItem>();
            mapsdata = ViewModelLocator.MainStatic.Stations.CurrentItems;
            foreach (YAStationItem item in mapsdata)
            {
                Pushpin pushpin = new Pushpin();
                MapLayer.SetPosition(pushpin, new Location(item.Lat, item.Lon));
                pushpin.Name = item.UniqueId;
                pushpin.Tapped += pushpinTapped;
                map.Children.Add(pushpin);
            };
            map.SetView(new Location(ViewModelLocator.MainStatic.Stations.Latitued, ViewModelLocator.MainStatic.Stations.Longitude), 11);
            
        }

        Flyout box = new Flyout();

        private async void pushpinTapped(object sender, Windows.UI.Xaml.Input.TappedRoutedEventArgs e)
        {
            Pushpin tappedpin = sender as Pushpin;  // gets the pin that was tapped
            if (null == tappedpin) return;  // null check to prevent bad stuff if it wasn't a pin.
            ViewModelLocator.MainStatic.Stations.CurrentStation = (YAStationItem)ViewModelLocator.MainStatic.Stations.CurrentItems.FirstOrDefault(c => c.UniqueId.ToString() == tappedpin.Name.ToString());

            var x = MapLayer.GetPosition(tappedpin);

            box = new Flyout();
            box.Placement = PlacementMode.Top;
            box.Content = new TouristControl();
            box.PlacementTarget = sender as UIElement;
            box.IsOpen = true;
            //MessageDialog dialog = new MessageDialog("You are here " + x.Latitude + " " + x.Longitude);
            //await dialog.ShowAsync();
        }

        private TappedEventHandler ShowFlyoutData()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Вызывается при щелчке элемента.
        /// </summary>
        /// <param name="sender">Объект GridView (или ListView, если приложение прикреплено),
        /// в котором отображается нажатый элемент.</param>
        /// <param name="e">Данные о событии, описывающие нажатый элемент.</param>
        void ItemView_ItemClick(object sender, ItemClickEventArgs e)
        {
            // Переход к соответствующей странице назначения и настройка новой страницы
            // путем передачи необходимой информации в виде параметра навигации
            var itemId = ((YAStationItem)e.ClickedItem).UniqueId;
            this.Frame.Navigate(typeof(StationDetailPage), itemId);
        }

        private void RegionSelect_Click(object sender, RoutedEventArgs e)
        {
            Flyout f = new Flyout();
            f.PlacementTarget = sender as UIElement;
            f.Placement = PlacementMode.Top;

            Menu menu = new Menu();

            MenuItem mi = new MenuItem();
            mi.Tag = "Easy";
            //mi.Tapped += ItemClicked;
            mi.Text = "Easy Game";
            mi.MenuTextMargin = new Thickness(28, 10, 28, 12);

            MenuItem mi2 = new MenuItem();
            mi2.Text = "Medium Game";
            mi2.Tag = "Medium";
            //mi2.Tapped += ItemClicked;
            mi2.MenuTextMargin = new Thickness(28, 10, 28, 12);

            MenuItem mi3 = new MenuItem();
            mi3.Text = "Hard Game";
            //mi3.Command = new CommandTest();
            mi3.CommandParameter = "test param from command";
            mi3.MenuTextMargin = new Thickness(28, 10, 28, 12);

            ToggleMenuItem tmi = new ToggleMenuItem();
            tmi.Text = "Enable Logging";
            //tmi.IsChecked = chk;
            tmi.Tapped += (a, b) =>
            {
                //chk = !chk;
            };

            menu.Items.Add(mi);
            menu.Items.Add(mi2);
            menu.Items.Add(new MenuItemSeparator());
            menu.Items.Add(new MenuItem() { Text = "Foobar something really long", Tag = "Long menu option", MenuTextMargin = new Thickness(28, 10, 28, 12) });
            menu.Items.Add(tmi);
            menu.Items.Add(new MenuItemSeparator());
            menu.Items.Add(mi3);
            f.HostMargin = new Thickness(0); // on menu flyouts set HostMargin to 0
            f.Content = menu;
            f.IsOpen = true;
        }
    }
}
