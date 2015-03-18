//
//  GLang.m
//  emptyProject
//
//  Created by A.O. on 18.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "GLang.h"


@implementation GLang
NSString* GLangCurrentPreferredLang=nil;
NSDictionary* GLangCurrentLangDict=nil;

+(void)initialize{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    language=@"ru";
    NSDictionary* dicts=
  @{
        @"en":
        @{
            @"Notes.temp.place":@"Place in English",
            @"Notes.temp.descr":@"This is description for lang english\nline2\nline3",
            @"Notes.segments.here":@"Here",
            @"Notes.segments.today":@"Today",
            @"Notes.segments.week":@"Week",
            @"Notes.segments.month":@"Month",
            @"Notes.segments.all":@"All",
            @"Notes.title":@"Notes",
            @"Notes.edit":@"Edit",
            @"Notes.tabbar.title":@"List",
            @"Notes.search.placeholder":@"Search",
            
            @"Settings.title":@"Settings",
            @"Settings.tabbar.title":@"Settings",
            @"Settings.category.sound":@"Sound",
            @"Settings.tune":@"Tune",
            @"Settings.mute":@"Mute",
            @"Settings.category.service":@"Service",
            @"Settings.clearcache":@"Delete temporary files",
            @"Settings.deletenotes":@"Delete all entries",
            @"Settings.category.terms":@"Terms",
            @"Settings.privacy":@"Privacy",
            @"Settings.termtouse":@"License",
            @"Settings.category.account":@"",
            @"Settings.account":@"Account",
            @"Settings.clearcache.title":@"Clear cache",
            @"Settings.clearcache.description":@"Clear cache successfull",
            @"Settings.clearentries.title":@"Clear cache",
            @"Settings.clearentries.description":@"Clear entries successfull",
            

            @"Places.tabbar.title":@"Places",
            @"Places.title":@"Places",
            @"Places.segments.here":@"Here",
            @"Places.segments.today":@"Today",
            @"Places.segments.all":@"All",
            
            @"EditCreate.category.task":@"Task",
            @"EditCreate.category.alerts":@"Notification",
            @"EditCreate.category.status":@"Status",
            //note
            @"EditCreate.category.note":@"Note",
            @"EditCreate.place":@"Place",
            @"EditCreate.date":@"Date",
            @"EditCreate.category":@"Category",
            @"EditCreate.note":@"Note",
            @"EditCreate.place_alert":@"Place notice",
            @"EditCreate.time_alert":@"Time notice",
            @"EditCreate.pause":@"Pause",
            @"EditCreate.complete":@"Complete",
            @"EditCreate.create.title":@"Create",
            @"EditCreate.edit.title":@"Edit",
            @"EditCreate.create_btn":@"Create",

            @"SelectDates.day.d1":@"Monday",
            @"SelectDates.day.d2":@"Tuesday",
            @"SelectDates.day.d3":@"Wednesday",
            @"SelectDates.day.d4":@"Thursday",
            @"SelectDates.day.d5":@"Friday",
            @"SelectDates.day.d6":@"Saturday",
            @"SelectDates.day.d7":@"Sunday",
            @"SelectDates.calendar":@"Calendar",
            @"SelectDates.clock":@"Clock",
            @"SelectDates.days":@"Days",
            @"SelectDates.title":@"Scheduler",
            
            @"SelectDates.clock.time":@"Time frame",
            @"SelectDates.clock.time_frame":@"Around the clock",
            
            @"DayNames.full.d1":@"monday",
            @"DayNames.full.d2":@"tuesday",
            @"DayNames.full.d3":@"wednesday",
            @"DayNames.full.d4":@"thursday",
            @"DayNames.full.d5":@"friday",
            @"DayNames.full.d6":@"saturday",
            @"DayNames.full.d7":@"sunday",

            @"DayNames.full.weekday_days":@"weekdays",
            @"DayNames.full.weekend_days":@"weekend",
            
            @"SelectSound.sound_system":@"System",
            @"SelectSound.title":@"Sound",
            
            @"Account.title":@"Account",
            @"Account.sign_up":@"Registration",
            @"Account.sign_in":@"Sign In",

            @"Account.login":@"Login",
            @"Account.password":@"Password",
            @"Account.firstname":@"Firstname",
            @"Account.lastname":@"Lastname",
            
            
            @"":@""
        },
    @"ru":
        @{
            @"Notes.temp.place":@"Место на русском",
            @"Notes.temp.descr":@"Описание места на русском\nстрока 2\nстрока 3",
            @"Notes.segments.here":@"Здесь",
            @"Notes.segments.today":@"Сегодня",
            @"Notes.segments.week":@"Неделя",
            @"Notes.segments.month":@"Месяц",
            @"Notes.segments.all":@"Все",
            @"Notes.title":@"Заметки",
            @"Notes.edit":@"Изменить",
            @"Notes.tabbar.title":@"Список",
            @"Notes.search.placeholder":@"Поиск",

            @"Settings.title":@"Настройки",
            @"Settings.tabbar.title":@"Настройки",
            @"Settings.category.sound":@"Звук",
            @"Settings.tune":@"Звук",
            @"Settings.mute":@"Без звука",
            @"Settings.category.service":@"Обслуживание",
            @"Settings.clearcache":@"Удалить временные файлы",
            @"Settings.deletenotes":@"Удалить все записи",
            @"Settings.category.terms":@"Правовая информация",
            @"Settings.privacy":@"Конфиденциальность",
            @"Settings.termtouse":@"Лицензия",
            @"Settings.category.account":@"",
            @"Settings.account":@"Учетная запись",
            @"Settings.clearcache.title":@"Удаление временных файлов",
            @"Settings.clearcache.description":@"Успешно",
            @"Settings.clearentries.title":@"Удаление всех записей",
            @"Settings.clearentries.description":@"Успешно",
            
            
            @"Places.tabbar.title":@"Места",
            @"Places.title":@"Места",
            @"Places.segments.here":@"Здесь",
            @"Places.segments.today":@"Сегодня",
            @"Places.segments.all":@"Все",
            
            @"EditCreate.category.note":@"Заметка",

            @"EditCreate.category.task":@"Задача",
            @"EditCreate.category.alerts":@"Оповещения",
            @"EditCreate.category.status":@"Состояние",
            @"EditCreate.place":@"Место",
            @"EditCreate.date":@"Дата",
            @"EditCreate.category":@"Категория",
            @"EditCreate.note":@"Заметка",
            @"EditCreate.place_alert":@"По местоположению",
            @"EditCreate.time_alert":@"По времени",
            @"EditCreate.pause":@"Приостановлено",
            @"EditCreate.complete":@"Завершено",
            @"EditCreate.create.title":@"Создать",
            @"EditCreate.edit.title":@"Изменить",
            @"EditCreate.create_btn":@"Создать",
            
            @"SelectDates.day.d1":@"Понедельник",
            @"SelectDates.day.d2":@"Вторник",
            @"SelectDates.day.d3":@"Среда",
            @"SelectDates.day.d4":@"Четверг",
            @"SelectDates.day.d5":@"Пятница",
            @"SelectDates.day.d6":@"Суббота",
            @"SelectDates.day.d7":@"Воскресенье",
            @"SelectDates.calendar":@"Календарь",
            @"SelectDates.clock":@"Часы",
            @"SelectDates.days":@"Дни недели",
            @"SelectDates.title":@"График",
            
            @"SelectDates.clock.time":@"Временные рамки",
            @"SelectDates.clock.time_frame":@"Круглосуточно",
            
            @"DayNames.full.d1":@"понедельник",
            @"DayNames.full.d2":@"вторник",
            @"DayNames.full.d3":@"среда",
            @"DayNames.full.d4":@"четверг",
            @"DayNames.full.d5":@"пятница",
            @"DayNames.full.d6":@"суббота",
            @"DayNames.full.d7":@"воскресенье",

            @"DayNames.full.weekday_days":@"будние дни",
            @"DayNames.full.weekend_days":@"выходные дни",
            
            @"SelectSound.sound_system":@"Системный",
            @"SelectSound.title":@"Звук",

            @"Account.title":@"Учетная запись",
            @"Account.sign_up":@"Регистрация",
            @"Account.sign_in":@"Вход",
            
            @"Account.login":@"Номер телефона",
            @"Account.password":@"Пароль",
            @"Account.firstname":@"Имя",
            @"Account.lastname":@"Фамилия",

            
            @"":@""
            
        }
  };
    NSDictionary* super_lang=[dicts objectForKey:language];
    if(super_lang==nil){
        super_lang=[dicts objectForKey:@"en"];
    }
    
    GLangCurrentLangDict=super_lang;
    GLangCurrentPreferredLang=language;
}
+(NSString*)getString:(NSString*)str{
    NSString* r=[GLangCurrentLangDict objectForKey:str];
    if(r!=nil){return r;}else{return @"lang_not_set";}
}

@end
