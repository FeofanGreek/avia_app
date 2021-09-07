import 'package:avia_app/pages/bottom_sheets/bottom_sheet_7.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../strings.dart';
import '../text_styles.dart';
import 'formaRFromReestrNew.dart';
import 'historySheet.dart';

List historyList = [{
  "changeDate" : "10.02.2021",
  "route" : {"out":"UUEE", "in" : "EPMO"}, // последний из роутов
  "routNumber" : "SU1306",
  "routeDateOut" : "09.04.2021",
  "routeTimeOut" : "11:00",
  "routeDateIn" : "10.04.2021",
  "routeTimeIn" : "16:00",
  "role" : "УРПРА", //последний из наследивших
  "status" : "Отклонено", //последний из статусов
  "historyBody":[
    /*{
      "route" : {"out":"UUEE", "in" : "EPMO"},
      "type" : "Примечание",
      "partOfForm" : "Основное ВС / Параметры",
      "header" : "Не корректный вес пустого снаряжения",
      "autor" : "Владелец",
      "body" : "",
      "status" : "Принято"
    },
    {
      "route" : {"out":"UUEE", "in" : "EPMO"},
      "type" : "Комментарий",
      "partOfForm" : "Основное ВС / Параметры",
      "header" : "Не корректный вес пустого снаряжения",
      "autor" : "Владелец",
      "body" : "",
      "status" : "Отправлено"
    },
    {
      "route" : {"out":"UUEE", "in" : "EPMO"},
      "type" : "Ошибка",
      "partOfForm" : "Основное ВС / Параметры",
      "header" : "Не корректный вес пустого снаряжения",
      "autor" : "Владелец",
      "body" : "",
      "status" : "Принято"
    },
    {
      "route" : {"out":"UUEE", "in" : "EPMO"},
      "type" : "Комментарий",
      "partOfForm" : "Основное ВС / Параметры",
      "header" : "Не корректный вес пустого снаряжения",
      "autor" : "Владелец",
      "body" : "",
      "status" : "Отправлено"
    },
    {
      "route" : {"out":"UUEE", "in" : "EPMO"},
      "type" : "Ошибка",
      "partOfForm" : "Основное ВС / Параметры",
      "header" : "Не корректный вес пустого снаряжения",
      "autor" : "Владелец",
      "body" : "",
      "status" : "Принято"
    },*/
  ]
},
  {
    "changeDate" : "10.02.2021",
    "route" : {"out":"UUEE", "in" : "EPMO"}, // последний из роутов
    "routNumber" : "SU1306",
    "routeDateOut" : "09.04.2021",
    "routeTimeOut" : "11:00",
    "routeDateIn" : "10.04.2021",
    "routeTimeIn" : "16:00",
    "role" : "УРПРА", //последний из наследивших
    "status" : "В обработке", //последний из статусов
    "historyBody":[
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Комментарий",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      }
    ]
  },
  {
    "changeDate" : "10.02.2021",
    "route" : {"out":"UUEE", "in" : "EPMO"}, // последний из роутов
    "routNumber" : "SU1306",
    "routeDateOut" : "09.04.2021",
    "routeTimeOut" : "11:00",
    "routeDateIn" : "10.04.2021",
    "routeTimeIn" : "16:00",
    "role" : "Владелец", //последний из наследивших
    "status" : "Отменено", //последний из статусов
    "historyBody":[
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      }
    ]
  },
  {
    "changeDate" : "10.02.2021",
    "route" : {"out":"UUEE", "in" : "EPMO"}, // последний из роутов
    "routNumber" : "SU1306",
    "routeDateOut" : "09.04.2021",
    "routeTimeOut" : "11:00",
    "routeDateIn" : "10.04.2021",
    "routeTimeIn" : "16:00",
    "role" : "Начальник УРПРА", //последний из наследивших
    "status" : "Утверждено", //последний из статусов
    "historyBody":[
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Комментарий",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      }
    ]
  },
  {
    "changeDate" : "10.02.2021",
    "route" : {"out":"UUEE", "in" : "EPMO"}, // последний из роутов
    "routNumber" : "SU1306",
    "routeDateOut" : "09.04.2021",
    "routeTimeOut" : "11:00",
    "routeDateIn" : "10.04.2021",
    "routeTimeIn" : "16:00",
    "role" : "УРПРА", //последний из наследивших
    "status" : "Согласовано", //последний из статусов
    "historyBody":[
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Комментарий",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      }
    ]
  },
  {
    "changeDate" : "10.02.2021",
    "route" : {"out":"UUEE", "in" : "EPMO"}, // последний из роутов
    "routNumber" : "SU1306",
    "routeDateOut" : "09.04.2021",
    "routeTimeOut" : "11:00",
    "routeDateIn" : "10.04.2021",
    "routeTimeIn" : "16:00",
    "role" : "S7", //последний из наследивших
    "status" : "Согласовано (10.02.2021)", //последний из статусов
    "historyBody":[
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Комментарий",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Комментарий",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Комментарий",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Комментарий",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Комментарий",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
    ]
  },
  {
    "changeDate" : "10.02.2021",
    "route" : {"out":"UUEE", "in" : "EPMO"}, // последний из роутов
    "routNumber" : "SU1306",
    "routeDateOut" : "09.04.2021",
    "routeTimeOut" : "11:00",
    "routeDateIn" : "10.04.2021",
    "routeTimeIn" : "16:00",
    "role" : "УРЭРА", //последний из наследивших
    "status" : "Ожидает обработки", //последний из статусов
    "historyBody":[
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Комментарий",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Примечание",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Комментарий",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
    ]
  },
  {
    "changeDate" : "10.02.2021",
    "route" : {"out":"UUEE", "in" : "EPMO"}, // последний из роутов
    "routNumber" : "SU1306",
    "routeDateOut" : "09.04.2021",
    "routeTimeOut" : "11:00",
    "routeDateIn" : "10.04.2021",
    "routeTimeIn" : "16:00",
    "role" : "УРПРА", //последний из наследивших
    "status" : "Передано в УЛЭРА", //последний из статусов
    "historyBody":[
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
    ]
  },
  {
    "changeDate" : "10.02.2021",
    "route" : {"out":"UUEE", "in" : "EPMO"}, // последний из роутов
    "routNumber" : "SU1306",
    "routeDateOut" : "09.04.2021",
    "routeTimeOut" : "11:00",
    "routeDateIn" : "10.04.2021",
    "routeTimeIn" : "16:00",
    "role" : "ГЦ Сидорова Т.П.", //последний из наследивших
    "status" : "Принято", //последний из статусов
    "historyBody":[
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
    ]
  },
  {
    "changeDate" : "10.02.2021",
    "route" : {"out":"UUEE", "in" : "EPMO"}, // последний из роутов
    "routNumber" : "SU1306",
    "routeDateOut" : "09.04.2021",
    "routeTimeOut" : "11:00",
    "routeDateIn" : "10.04.2021",
    "routeTimeIn" : "16:00",
    "role" : "Владелец", //последний из наследивших
    "status" : "Ответ", //последний из статусов
    "historyBody":[
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
    ]
  },{
    "changeDate" : "10.02.2021",
    "route" : {"out":"UUEE", "in" : "EPMO"}, // последний из роутов
    "routNumber" : "SU1306",
    "routeDateOut" : "09.04.2021",
    "routeTimeOut" : "11:00",
    "routeDateIn" : "10.04.2021",
    "routeTimeIn" : "16:00",
    "role" : "Владелец", //последний из наследивших
    "status" : "Запрос информации", //последний из статусов
    "historyBody":[
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Принято"
      },
      {
        "route" : {"out":"UUEE", "in" : "EPMO"},
        "type" : "Ошибка",
        "partOfForm" : "Основное ВС / Параметры",
        "header" : "Не корректный вес пустого снаряжения",
        "autor" : "Владелец",
        "body" : "",
        "status" : "Отправлено"
      },
    ]
  }];

List switcher = [];

class historyPage extends StatefulWidget {
  @override
  _formaNFishPageScreenState createState() => _formaNFishPageScreenState();
}

class _formaNFishPageScreenState extends State<historyPage> {




  @override
  void initState() {
    for(int i = 0; i < historyList.length; i++){
      switcher.add(false);
    }
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      appBar:AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: kBlue,
        title: Container(
            width:MediaQuery.of(context).size.width ,
            child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      headerValue = s251;
                      Navigator.pushNamed(context, '/HomePage');},
                    child:Container(
                      margin: EdgeInsets.fromLTRB(0,7,0,0),
                      width:MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child:
                      //Column(
                      //  children: <Widget>[
                      Icon(CupertinoIcons.chevron_left, color: kYellow, size: 20,),
                      //Text(s4,style: st10,),
                      //]),
                    ),
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child:
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(onTap: (){
                            Navigator.pushReplacement(context,
                                CupertinoPageRoute(builder: (context) => formaRFromReestrPage()));
                          }, child:Container(
                                width: MediaQuery.of(context).size.width / 4 -20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: kWhite2),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14.0),
                                      bottomLeft: Radius.circular(14.0)),
                                  color: kBlue,
                                ),
                                child: Text(s252, style: st17,textAlign: TextAlign.center,)
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                //regSwitch = true;
                              });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width / 4 -20,
                                height: 31,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: kYellow),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(14.0),
                                      bottomRight: Radius.circular(14.0)),
                                  color: kYellow,
                                ),
                                child: Text(s253, style: st17,textAlign: TextAlign.center,)
                            ),
                          ),

                          Container(
                            height: 40,
                            //width: 100,
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(30,0,0,0),
                            child: TextButton(
                              onPressed:(){
                              } ,
                              child: Text(vocabular['myPhrases']['process'], style: TextStyle(fontSize: 12.0,fontFamily: 'AlS Hauss', color: kWhite,),textAlign: TextAlign.center,),
                              style: ElevatedButton.styleFrom(
                                primary: kYellow,
                                minimumSize: Size(20, 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ])
        ),
      ),
      body:Container(
        width:MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: kBlue,
        ),
        child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
                margin: EdgeInsets.fromLTRB(10,0,10,0),
                child:ListView.builder(
                    padding: EdgeInsets.only(left: 8),
                    //scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                        return GestureDetector(onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: kTrans,
                              context: context,
                              builder: (context) {
                                return historySheet();
                              });

                          setState(() {
                            selectedTabHistory = index;
                          //historyList[index]['historyBody'].length > 0 ? switcher[index] = !switcher[index] : null;
                        });}, child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              SizedBox(height: 10,),
                              Text(
                                '${historyList[index]['changeDate']}',
                                style: st6,
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children:[
                                  //Spacer(),
                                  //SizedBox(width: 10,),
                                  Expanded( child:Text(
                                    '${historyList[index]['routNumber']} - ${historyList[index]['routeDateIn']}',
                                    style: TextStyle(fontSize: 16,fontFamily: 'AlS Hauss',),
                                  )),
                                  SizedBox(width: 10,),
                                  //Spacer(),
                                 Text(
                                    '${historyList[index]['status']}',
                                    style: TextStyle(fontSize: 14,fontFamily: 'AlS Hauss',color: historyList[index]['status'] == 'Отклонено' ? Color(0xFFFF5A43) : historyList[index]['status'] == 'Утверждено' ? Color(0xFF00FF2C) : historyList[index]['status'] == 'Принято' ? Color(0xFFCF9400) :historyList[index]['status'] == 'Запрос информации' ? Color(0xFF337AD9) : kWhite),
                                  ),
                                ]
                              ),
                              SizedBox(height: 5,),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                      children: [
                                        Expanded( child:Text(
                                          '${historyList[index]['route']['out']} → ${historyList[index]['route']['in']} ${historyList[index]['routeTimeIn']}',
                                          style: st14, textAlign: TextAlign.left,
                                        )),
                                        SizedBox(width: 10,),
                                        Text(
                                          '${historyList[index]['role']}',
                                          style: st14,
                                        ),
                                      ])),
                              SizedBox(height: 5,),
                              historyList[index]['historyBody'].length > 0 ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                  children:[
                                    Image.asset(
                                        'icons/triangle_red.png', width: 16,
                                        height: 16,
                                        fit: BoxFit.fitHeight),
                                    SizedBox(width: 5,),
                                    Text('${historyList[index]['historyBody'].length} примечани${historyList[index]['historyBody'].length.toString()[(historyList[index]['historyBody'].length.toString().length - 1)] == '1' ? 'е' : historyList[index]['historyBody'].length.toString()[(historyList[index]['historyBody'].length.toString().length - 1)] == '2' ? 'я' : historyList[index]['historyBody'].length.toString()[(historyList[index]['historyBody'].length.toString().length - 1)] == '3' ? 'я' : historyList[index]['historyBody'].length.toString()[(historyList[index]['historyBody'].length.toString().length - 1)] == '4' ? 'я' : 'й'}', style:st15),
                                    Spacer(),
                                    Icon(CupertinoIcons.chevron_right, size: 15, color: kWhite3,)
                                      ]): Container(),
                              SizedBox(height: 5,),
                              Divider(height: 2,thickness: 2,color: kWhite1,),
                              /*Container(
                                child:ListView.builder(
                                    padding: EdgeInsets.only(left: 8),
                                    //scrollDirection: Axis.horizontal,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: historyList[index]['historyBody'].length,
                                    itemBuilder: (context, index2) {
                                        return switcher[index] == true ? Container( margin: EdgeInsets.fromLTRB(20,0,0,0),child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              SizedBox(height: 10,),
                                                    Text(
                                                      '${historyList[index]['historyBody'][index2]['header']}',
                                                      style: TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: historyList[index]['historyBody'][index2]['type'] == 'Ошибка' ? Color(0xFFEB5757) : historyList[index]['historyBody'][index2]['type'] == 'Примечание' ? Color(0xFF337AD9) : kWhite), textAlign: TextAlign.left,
                                                    ),
                                                    Row(
                                                      children: [
                                                         Text(
                                                            '${historyList[index]['historyBody'][index2]['partOfForm']}',
                                                            style: TextStyle(fontSize: 14,fontFamily: 'AlS Hauss', color: kWhite2), textAlign: TextAlign.left,
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            children: [
                                                              Text(
                                                                  '${historyList[index]['historyBody'][index2]['status']}',
                                                                  style: TextStyle(fontSize: 14,fontFamily: 'AlS Hauss',color: Color(0xFFCF9400)),
                                                                ),
                                                              Text(
                                                                historyList[index]['historyBody'][index2]['autor'],
                                                                style: st17, textAlign: TextAlign.left,
                                                              ),
                                                          ]),
                                                    ]),
                                              SizedBox(height: 5,),
                                              Divider(height: 1,thickness: 1,color: kWhite1,),
                                          ])) : Container();}
                                      )),*/
                              switcher[index] == true ? SizedBox(height: 30,) : Container(),
                                  ]));
                    }
          )
        ),
      ),
    ));
  }
}