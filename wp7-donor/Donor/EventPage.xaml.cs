﻿using System;
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
using Microsoft.Phone.Tasks;

namespace Donor
{
    public partial class EventPage : PhoneApplicationPage
    {
        public EventPage()
        {
            InitializeComponent();
        }
        private string _eventid_current;
        private EventViewModel _currentEvent;
        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (this.NavigationContext.QueryString.ContainsKey("id"))
            {
                try
                {
                    string _eventid = this.NavigationContext.QueryString["id"];
                    _eventid_current = _eventid;
                    _currentEvent = App.ViewModel.Events.Items.FirstOrDefault(c => c.Id == _eventid.ToString());
                    DataContext = _currentEvent;

                    if (_currentEvent.Type != "1")
                    {
                        this.FinishedMenu.Visibility = Visibility.Collapsed;
                    } else {
                        if (_currentEvent.Finished == false)
                        {
                            this.FinishedMenu.Visibility = Visibility.Visible;
                            this.EditButton.Visibility = Visibility.Visible;
                        }
                        else
                        {
                            this.EditButton.Visibility = Visibility.Collapsed;
                            this.FinishedMenu.Visibility = Visibility.Collapsed;
                        };
                    };

                    if (_currentEvent.Type != "0" && _currentEvent.Type != "1")
                    {
                        this.AppBar.Visibility = Visibility.Collapsed;
                        this.AppBar.IsVisible = false;
						ReminderStackPanel.Visibility = Visibility.Collapsed;
                    };
					
					if (_currentEvent.Type == "0")
                    {                        
						this.ic_be_tested.Visibility = Visibility.Visible;
						ReminderStackPanel.Visibility = Visibility.Visible;
                        this.TitleNews.Text = "Сдать анализ";
                        this.Reminder.Text = _currentEvent.ReminderDate.ToString();
                        this.Finished.Visibility = Visibility.Collapsed;

                        this.ApplicationTitle.Text = "анализ";
                        
                    };
					if (_currentEvent.Type == "1")
                    {
                        this.TitleNews.Text = _currentEvent.GiveType;
						ReminderStackPanel.Visibility = Visibility.Collapsed;

                        this.ApplicationTitle.Text = "кроводача";
                    };

                    if (_currentEvent.Type == "Праздник")
                    {
                        this.ApplicationTitle.Text = "праздник";
                        this.Finished.Visibility = Visibility.Collapsed;
                        this.Time.Visibility = Visibility.Collapsed;
                    };
                   
                }
                catch
                {
                    NavigationService.GoBack();
                };
            }
            else
            {
                NavigationService.GoBack();
            };
        }

        private void ShareButton_Click(object sender, EventArgs e)
        {
            //App.ViewModel.SendToShare(_currentNews.Title, _currentNews.Link, _currentNews.Description, 130);
        }

        private void AdvancedApplicationBarIconButton_Click(object sender, EventArgs e)
        {
            WebBrowserTask webTask = new WebBrowserTask();
            //webTask.Uri = new Uri(_currentNews.Link);
            webTask.Show();
        }

        private void DeleteButton_Click(object sender, EventArgs e)
        {
            try
            {
                App.ViewModel.Events.Items.Remove(_currentEvent);
                App.ViewModel.Events.UpdateItems(); 

                NavigationService.GoBack();
            }
            catch
            {
                NavigationService.GoBack();
            };
        }

        private void EditButton_Click(object sender, EventArgs e)
        {
            try {
                NavigationService.Navigate(new Uri("/EventEditPage.xaml?id=" + _currentEvent.Id, UriKind.Relative));
            }
            catch {
            };
        }

        private void StackPanel_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
        	// TODO: Add event handler implementation here.
        }

        private void Image_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/MapPage.xaml"));
            }
            catch
            {
            };
        }

        private void AdvancedApplicationBarMenuItem_Click(object sender, System.EventArgs e)
        {

        }

        private void AdvancedApplicationBarMenuItem_Click_1(object sender, EventArgs e)
        {
            try
            {
                if (_currentEvent.Finished == false)
                {
                    if ((_currentEvent.Date <= DateTime.Today) && (_currentEvent.Time.Hour <= DateTime.Now.Hour) && (_currentEvent.Time.Minute <= DateTime.Now.Minute))
                    {
                        App.ViewModel.Events.Items.Remove(_currentEvent);
                        _currentEvent.Finished = true;
                        App.ViewModel.Events.Items.Add(_currentEvent);

                        App.ViewModel.Events.UpdateItems();

                        MessageBox.Show("Вы сдали кровь. Спасибо! Рассчитан интервал до следующей возможной кроводачи");
                    }
                    else {
                        MessageBox.Show("Кроводача еще не может быть выполнена.");
                    };
                }
                else
                {
                };
            }
            catch
            {
            };
        }
    }
}