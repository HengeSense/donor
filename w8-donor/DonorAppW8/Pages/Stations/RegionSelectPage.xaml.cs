﻿//using DonorAppW8.Data;

using Bing.Maps;
using Callisto.Controls;
using DonorAppW8.Controls;
using DonorAppW8.DataModel;
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
    public sealed partial class RegionSelectPage : DonorAppW8.Common.LayoutAwarePage
    {
        public RegionSelectPage()
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
            //var group = ViewModelLocator.MainStatic.Groups.FirstOrDefault(c => c.UniqueId ==(String)navigationParameter);
            //this.DefaultViewModel["Group"] = new RssDataGroup() { UniqueId==""};
            this.DefaultViewModel["Items"] = ViewModelLocator.MainStatic.Stations.RegionItems;
        }

        Flyout box = new Flyout();

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
            var itemId = ((RegionItem)e.ClickedItem).Title;
            ViewModelLocator.MainStatic.Stations.State = itemId;
            ViewModelLocator.MainStatic.Stations.UpdateStationsGroup();

            this.Frame.GoBack();
            //this.Frame.Navigate(typeof(StationDetailPage), itemId);
        }

    }
}