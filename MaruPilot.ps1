param([switch]$AuditOnly)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'
$appDirectory = Join-Path $env:APPDATA 'MaruPilot'
$configPath = Join-Path $appDirectory 'settings.json'
$logPath = Join-Path $appDirectory 'changes.log'
$config = @{
    PolicyBackups = @{}
    Language = 'EN'
}
$script:currentLanguage = 'EN'
$script:strings = @{
    WindowTitle = @{ EN = 'MaruPilot - Copilot controls'; HU = 'MaruPilot - Copilot-beállítások'; UK = 'MaruPilot — керування Copilot'; RU = 'MaruPilot — управление Copilot' }
    Description = @{ EN = 'Manage supported Copilot policies'; HU = 'A támogatott Copilot-házirendek kezelése'; UK = 'Керування підтримуваними політиками Copilot'; RU = 'Управление поддерживаемыми политиками Copilot' }
    ChannelLabel = @{ EN = 'Author YouTube channel:'; HU = 'A szerző YouTube-csatornája:'; UK = 'YouTube-канал автора:'; RU = 'YouTube-канал автора:' }
    ChannelLink = @{ EN = 'Open YouTube channel'; HU = 'YouTube-csatorna megnyitása'; UK = 'Відкрити канал на YouTube'; RU = 'Открыть канал на YouTube' }
    Notice = @{ EN = 'Only selected policies are changed. Office, the new Copilot app, and Copilot+ may remain enabled; see the system audit.'; HU = 'Csak a kiválasztott házirendek változnak. Az Office, az új Copilot-alkalmazás és a Copilot+ bekapcsolva maradhat; lásd a rendszerellenőrzést.'; UK = 'Змінюються лише вибрані політики. Office, новий застосунок Copilot і Copilot+ можуть залишитися ввімкненими; див. аудит системи.'; RU = 'Изменяются только выбранные политики. Office, новое приложение Copilot и Copilot+ могут остаться включёнными; подробности — в проверке системы.' }
    ButtonBlock = @{ EN = 'Block Copilot'; HU = 'Copilot letiltása'; UK = 'Заблокувати Copilot'; RU = 'Заблокировать Copilot' }
    ButtonRestore = @{ EN = 'Restore settings'; HU = 'Beállítások visszaállítása'; UK = 'Відновити налаштування'; RU = 'Восстановить настройки' }
    ButtonCheck = @{ EN = 'Check system'; HU = 'Rendszer ellenőrzése'; UK = 'Перевірити систему'; RU = 'Проверить систему' }
    StatusNone = @{ EN = 'Status: no Copilot policies configured'; HU = 'Állapot: nincs Copilot-házirend beállítva'; UK = 'Статус: політики Copilot не налаштовані'; RU = 'Статус: политики Copilot не настроены' }
    StatusCount = @{ EN = 'Status: Copilot policies configured - {0}'; HU = 'Állapot: beállított Copilot-házirendek - {0}'; UK = 'Статус: налаштовано політик Copilot — {0}'; RU = 'Статус: настроено политик Copilot — {0}' }
    StatusError = @{ EN = 'Check failed: {0}'; HU = 'Ellenőrzési hiba: {0}'; UK = 'Помилка перевірки: {0}'; RU = 'Ошибка проверки: {0}' }
    MenuAudit = @{ EN = 'Check system'; HU = 'Rendszer ellenőrzése'; UK = 'Перевірити систему'; RU = 'Проверить систему' }
    MenuRestore = @{ EN = 'Restore settings'; HU = 'Beállítások visszaállítása'; UK = 'Відновити налаштування'; RU = 'Восстановить настройки' }
    MenuLog = @{ EN = 'Open change log'; HU = 'Változási napló megnyitása'; UK = 'Відкрити журнал змін'; RU = 'Открыть журнал изменений' }
    TipStatus = @{ EN = 'Right-click to check components, restore settings, or open the log.'; HU = 'Kattintson a jobb gombbal az összetevők ellenőrzéséhez, a beállítások visszaállításához vagy a napló megnyitásához.'; UK = 'Клацніть правою кнопкою, щоб перевірити компоненти, відновити налаштування або відкрити журнал.'; RU = 'Щёлкните правой кнопкой мыши, чтобы проверить компоненты, восстановить настройки или открыть журнал.' }
    TipButton = @{ EN = 'Right-click for the system check and change log.'; HU = 'A rendszerellenőrzéshez és a változási naplóhoz kattintson a jobb gombbal.'; UK = 'Клацніть правою кнопкою для перевірки системи та журналу змін.'; RU = 'Щёлкните правой кнопкой для проверки системы и журнала изменений.' }
    AuditTitle = @{ EN = 'COPILOT COMPONENT AUDIT'; HU = 'COPILOT-ÖSSZETEVŐK ELLENŐRZÉSE'; UK = 'АУДИТ КОМПОНЕНТІВ COPILOT'; RU = 'АУДИТ КОМПОНЕНТОВ COPILOT' }
    DatePrefix = @{ EN = 'Time: {0}'; HU = 'Időpont: {0}'; UK = 'Час: {0}'; RU = 'Время: {0}' }
    StatePrefix = @{ EN = 'Status: {0}'; HU = 'Állapot: {0}'; UK = 'Стан: {0}'; RU = 'Состояние: {0}' }
    DetailsPrefix = @{ EN = 'Details: {0}'; HU = 'Részletek: {0}'; UK = 'Деталі: {0}'; RU = 'Подробности: {0}' }
    AuditFooter = @{ EN = 'Policies are written for the current user only and usually persist across restarts. Windows updates or organization policies may change them.'; HU = 'A házirendek csak az aktuális felhasználóra vonatkoznak, és általában újraindítás után is megmaradnak. A Windows-frissítések vagy a szervezeti házirendek módosíthatják őket.'; UK = 'Політики записуються лише для поточного користувача й зазвичай зберігаються після перезавантаження. Оновлення Windows або політики організації можуть їх змінити.'; RU = 'Политики записываются только для текущего пользователя и обычно сохраняются после перезагрузки. Обновления Windows или политики организации могут их изменить.' }
    PolicyWindowsTitle = @{ EN = 'Classic Windows Copilot'; HU = 'Klasszikus Windows Copilot'; UK = 'Класичний Windows Copilot'; RU = 'Классический Windows Copilot' }
    PolicyWindowsDetails = @{ EN = 'Turns off the classic Windows Copilot pane. Microsoft marks this policy as deprecated; it does not block the new Copilot app.'; HU = 'Kikapcsolja a klasszikus Windows Copilot-panelt. A Microsoft elavultnak jelöli ezt a házirendet; az új Copilot-alkalmazást nem tiltja le.'; UK = 'Вимикає класичну панель Windows Copilot. Microsoft позначає цю політику як застарілу; новий застосунок Copilot вона не блокує.'; RU = 'Отключает классическую панель Windows Copilot. Microsoft помечает эту политику как устаревшую; новое приложение Copilot она не блокирует.' }
    PolicyWindowsShort = @{ EN = 'Enable the official TurnOffWindowsCopilot policy.'; HU = 'A hivatalos TurnOffWindowsCopilot-házirend engedélyezése.'; UK = 'Увімкнути офіційну політику TurnOffWindowsCopilot.'; RU = 'Включить официальную политику TurnOffWindowsCopilot.' }
    PolicyEdgeTitle = @{ EN = 'Microsoft 365 Copilot Chat button in Edge'; HU = 'Microsoft 365 Copilot Chat-gomb az Edge-ben'; UK = 'Кнопка Microsoft 365 Copilot Chat в Edge'; RU = 'Кнопка Microsoft 365 Copilot Chat в Edge' }
    PolicyEdgeDetails = @{ EN = 'Hides Copilot Chat in the Edge for Business toolbar for supported Entra ID profiles on Edge 139+. It does not block Copilot on websites or other profiles.'; HU = 'Elrejti a Copilot Chat ikont az Edge for Business eszköztárán a támogatott, Edge 139+ verziójú Entra ID-profiloknál. Webhelyeken vagy más profilokban nem tiltja le a Copilotot.'; UK = 'Приховує Copilot Chat на панелі Edge for Business у підтримуваних профілях Entra ID для Edge 139+. Не блокує Copilot на сайтах чи в інших профілях.'; RU = 'Скрывает Copilot Chat на панели Edge for Business в поддерживаемых профилях Entra ID для Edge 139+. Не блокирует Copilot на сайтах и в других профилях.' }
    PolicyEdgeShort = @{ EN = 'Hide Copilot Chat in supported Edge profiles.'; HU = 'A Copilot Chat elrejtése a támogatott Edge-profilokban.'; UK = 'Приховати Copilot Chat у підтримуваних профілях Edge.'; RU = 'Скрыть Copilot Chat в поддерживаемых профилях Edge.' }
    PolicySidebarTitle = @{ EN = 'Entire Microsoft Edge sidebar'; HU = 'A teljes Microsoft Edge-oldalsáv'; UK = 'Уся бічна панель Microsoft Edge'; RU = 'Вся боковая панель Microsoft Edge' }
    PolicySidebarDetails = @{ EN = 'Hides the entire Edge sidebar, including apps and features unrelated to Copilot.'; HU = 'Elrejti az Edge teljes oldalsávját, beleértve a Copilothoz nem kapcsolódó alkalmazásokat és funkciókat.'; UK = 'Приховує всю бічну панель Edge, зокрема програми та функції, що не стосуються Copilot.'; RU = 'Скрывает всю боковую панель Edge, включая приложения и функции, не относящиеся к Copilot.' }
    PolicySidebarShort = @{ EN = 'Optional: turn off the whole sidebar, including other apps.'; HU = 'Nem kötelező: a teljes oldalsáv kikapcsolása más alkalmazásokkal együtt.'; UK = 'За бажанням вимкніть усю панель, включно з іншими програмами.'; RU = 'Необязательно: выключить всю панель, включая другие приложения.' }
    UserNotConfigured = @{ EN = 'Current user: not configured.'; HU = 'Aktualis felhasznalo: nincs beallitva.'; UK = 'Поточний користувач: не налаштовано.'; RU = 'Текущий пользователь: не задана.' }
    PolicyEnabled = @{ EN = 'Current user: disable policy is enabled.'; HU = 'Aktualis felhasznalo: a letilto hazirend engedelyezve.'; UK = 'Поточний користувач: політику вимкнення ввімкнено.'; RU = 'Текущий пользователь: политика отключения включена.' }
    PolicyUnexpected = @{ EN = 'Current user: unexpected type {0}, value {1}.'; HU = 'Aktualis felhasznalo: varatlan tipus {0}, ertek {1}.'; UK = 'Поточний користувач: неочікуваний тип {0}, значення {1}.'; RU = 'Текущий пользователь: неожиданный тип {0}, значение {1}.' }
    PolicyValue = @{ EN = 'Current user: value {0} (this policy does not disable Copilot).'; HU = 'Aktualis felhasznalo: {0} ertek (ez a hazirend nem tiltja le a Copilotot).'; UK = 'Поточний користувач: значення {0} (ця політика не вимикає Copilot).'; RU = 'Текущий пользователь: значение {0} (эта политика не отключает Copilot).' }
    DeviceDisabled = @{ EN = ' Device: disable policy is enabled.'; HU = ' Eszkoz: a letilto hazirend engedelyezve.'; UK = ' Пристрій: політику вимкнення ввімкнено.'; RU = ' Устройство: политика отключения включена.' }
    DeviceValue = @{ EN = ' Device: value {0} ({1}).'; HU = ' Eszkoz: {0} ertek ({1}).'; UK = ' Пристрій: значення {0} ({1}).'; RU = ' Устройство: значение {0} ({1}).' }
    PackageNone = @{ EN = 'no current-user packages found'; HU = 'nem talalhato csomag az aktualis felhasznalonel'; UK = 'пакетів поточного користувача не знайдено'; RU = 'пакеты текущего пользователя не найдены' }
    ProcessNone = @{ EN = 'no processes found'; HU = 'nem talalhato folyamat'; UK = 'процесів не знайдено'; RU = 'процессы не найдены' }
    PackagesLabel = @{ EN = 'packages'; HU = 'csomagok'; UK = 'пакети'; RU = 'пакеты' }
    ProcessesLabel = @{ EN = 'processes'; HU = 'folyamatok'; UK = 'процеси'; RU = 'процессы' }
    Detection = @{ EN = 'Copilot detection: {0}; {1}.'; HU = 'Copilot eszleles: {0}; {1}.'; UK = 'Виявлення Copilot: {0}; {1}.'; RU = 'Обнаружение Copilot: {0}; {1}.' }
    DetectionError = @{ EN = 'Could not check Copilot packages: {0}'; HU = 'A Copilot-csomagok ellenorzese sikertelen: {0}'; UK = 'Не вдалося перевірити пакети Copilot: {0}'; RU = 'Не удалось проверить пакеты Copilot: {0}' }
    RemovalStatus = @{ EN = 'User: {0}; device: {1}.'; HU = 'Felhasznalo: {0}; eszkoz: {1}.'; UK = 'Користувач: {0}; пристрій: {1}.'; RU = 'Пользователь: {0}; устройство: {1}.' }
    KeyUnset = @{ EN = 'Copilot key assignment policy is not configured.'; HU = 'A Copilot-billentyu hozzarendelese nincs beallitva.'; UK = 'Політику призначення клавіші Copilot не налаштовано.'; RU = 'Политика назначения клавиши Copilot не задана.' }
    KeySet = @{ EN = 'Copilot key assignment policy is {0} ({1}); it does not disable the app.'; HU = 'A Copilot-billentyu hazirendje: {0} ({1}); ez nem tiltja le az alkalmazast.'; UK = 'Політика клавіші Copilot: {0} ({1}); вона не вимикає програму.'; RU = 'Политика клавиши Copilot: {0} ({1}); она не отключает приложение.' }
    OfficeNone = @{ EN = 'Microsoft 365 Apps Click-to-Run was not found; other Office install types and licenses were not checked.'; HU = 'Microsoft 365 Apps Click-to-Run nem talalhato; mas Office-telepitesek es licencek nem lettek ellenorizve.'; UK = 'Microsoft 365 Apps Click-to-Run не знайдено; інші типи Office та ліцензії не перевірялися.'; RU = 'Microsoft 365 Apps Click-to-Run не обнаружен; другие типы установки Office и лицензии не проверялись.' }
    OfficeUnknown = @{ EN = 'Office Click-to-Run found; product release is unknown.'; HU = 'Office Click-to-Run megtalalhato; a kiadas nem ismert.'; UK = 'Office Click-to-Run виявлено; випуск не визначено.'; RU = 'Office Click-to-Run обнаружен; выпуск не определён.' }
    OfficeFound = @{ EN = 'Office products found: {0}.'; HU = 'Talalt Office-termekek: {0}.'; UK = 'Знайдено продукти Office: {0}.'; RU = 'Обнаружены продукты Office: {0}.' }
    StartupFolder = @{ EN = 'Startup folder: {0}'; HU = 'Inditomappa: {0}'; UK = 'Папка автозавантаження: {0}'; RU = 'Папка автозагрузки: {0}' }
    ScheduledTask = @{ EN = 'Scheduled task: {0}'; HU = 'Utemezett feladat: {0}'; UK = 'Завдання планувальника: {0}'; RU = 'Задание планировщика: {0}' }
    TaskError = @{ EN = 'Scheduled tasks could not be checked: {0}'; HU = 'Az utemezett feladatok ellenorzese sikertelen: {0}'; UK = 'Не вдалося перевірити завдання планувальника: {0}'; RU = 'Не удалось проверить задания планировщика: {0}' }
    NoNpu = @{ EN = 'No NPU name found. This does not rule out a Copilot+ PC; certification and NPU performance could not be confirmed.'; HU = 'NPU-nev nem talalhato. Ez nem zarja ki a Copilot+ PC-t; a tanusitas es a teljesitmeny nem ellenorizheto.'; UK = 'Назву NPU не знайдено. Це не виключає Copilot+ PC; сертифікацію та продуктивність не підтверджено.'; RU = 'Имя NPU не найдено. Это не исключает Copilot+ PC; сертификация и производительность не подтверждены.' }
    NpuFound = @{ EN = 'Possible NPU devices: {0}. This does not confirm Copilot+ certification or 40 TOPS.'; HU = 'Lehetseges NPU-eszkozok: {0}. Ez nem igazolja a Copilot+ tanusitast vagy a 40 TOPS teljesitmenyt.'; UK = 'Можливі пристрої NPU: {0}. Це не підтверджує сертифікацію Copilot+ або 40 TOPS.'; RU = 'Возможные устройства NPU: {0}. Это не подтверждает сертификацию Copilot+ или 40 TOPS.' }
    NpuError = @{ EN = 'Could not check NPU devices: {0}'; HU = 'Az NPU-eszkozok ellenorzese sikertelen: {0}'; UK = 'Не вдалося перевірити пристрої NPU: {0}'; RU = 'Не удалось проверить устройства NPU: {0}' }
    RecallStatus = @{ EN = 'AllowRecallEnablement: user={0}, device={1}; DisableAIDataAnalysis: user={2}, device={3}. MaruPilot changes neither policy nor Recall data.'; HU = 'AllowRecallEnablement: felhasznalo={0}, eszkoz={1}; DisableAIDataAnalysis: felhasznalo={2}, eszkoz={3}. A MaruPilot nem modositja ezeket vagy a Recall-adatokat.'; UK = 'AllowRecallEnablement: користувач={0}, пристрій={1}; DisableAIDataAnalysis: користувач={2}, пристрій={3}. MaruPilot не змінює ці політики чи дані Recall.'; RU = 'AllowRecallEnablement: пользователь={0}, устройство={1}; DisableAIDataAnalysis: пользователь={2}, устройство={3}. MaruPilot не меняет эти политики и данные Recall.' }
    PolicyFailure = @{ EN = 'Could not check policy: {0}'; HU = 'A hazirend ellenorzese sikertelen: {0}'; UK = 'Не вдалося перевірити політику: {0}'; RU = 'Не удалось проверить политику: {0}' }
    AuditFailure = @{ EN = 'System audit failed: {0}'; HU = 'A rendszerellenorzes sikertelen: {0}'; UK = 'Помилка аудиту системи: {0}'; RU = 'Проверка системы завершилась ошибкой: {0}' }
    ConfirmFailure = @{ EN = 'Could not prepare changes: {0}'; HU = 'A modositasok elokeszitese sikertelen: {0}'; UK = 'Не вдалося підготувати зміни: {0}'; RU = 'Не удалось подготовить изменения: {0}' }
    NewAppTitle = @{ EN = 'Microsoft Copilot app'; HU = 'Microsoft Copilot alkalmazas'; UK = 'Застосунок Microsoft Copilot'; RU = 'Приложение Microsoft Copilot' }
    NewAppDetails = @{ EN = 'A process or package name is only a clue, not proof it is Microsoft Copilot. The documented removal policy may uninstall the app under limited conditions; MaruPilot does not uninstall it.'; HU = 'A folyamat- vagy csomagnev csak jelzes, nem bizonyitek arra, hogy Microsoft Copilot. A dokumentalt eltavolitasi hazirend korlatozott feltetelekkel eltavolithatja az alkalmazast; a MaruPilot nem tavolitja el.'; UK = 'Назва процесу або пакета — лише підказка, а не підтвердження, що це Microsoft Copilot. Документована політика видалення може прибрати програму за певних умов; MaruPilot її не видаляє.'; RU = 'Имя процесса или пакета — лишь подсказка, а не подтверждение, что это Microsoft Copilot. Документированная политика удаления может удалить приложение при определённых условиях; MaruPilot его не удаляет.' }
    RemovalTitle = @{ EN = 'Copilot app removal policy'; HU = 'Copilot-alkalmazas eltavolitasi hazirend'; UK = 'Політика видалення програми Copilot'; RU = 'Политика удаления приложения Copilot' }
    RemovalDetails = @{ EN = 'Available only on certain Windows 11 editions and installs when the app has not been launched for 28 days. It can remove the app, not reliably block it; MaruPilot does not enable it.'; HU = 'Csak bizonyos Windows 11-kiadasokon es telepiteseknel erheto el, ha az alkalmazast 28 napja nem inditottak el. Eltavolithatja az alkalmazast, de nem tiltja le megbizhatoan; a MaruPilot nem engedelyezi.'; UK = 'Доступна лише в певних редакціях Windows 11 та за умови, що програму не запускали 28 днів. Вона може видалити програму, але не гарантує блокування; MaruPilot її не вмикає.'; RU = 'Доступна только в некоторых редакциях Windows 11 и если приложение не запускали 28 дней. Может удалить приложение, но не гарантирует блокировку; MaruPilot её не включает.' }
    KeyTitle = @{ EN = 'Copilot keyboard key'; HU = 'Copilot-billentyu'; UK = 'Клавіша Copilot'; RU = 'Клавиша Copilot' }
    KeyDetails = @{ EN = 'The key assignment policy can redirect the key but does not disable Copilot. The setting is only reported.'; HU = 'A billentyu-hozzarendelesi hazirend atiranyithatja a billentyut, de nem tiltja le a Copilotot. A beallitas csak megjelenik.'; UK = 'Політика призначення клавіші може перенаправити її, але не вимикає Copilot. Налаштування лише показується.'; RU = 'Политика назначения клавиши может перенаправить её, но не отключает Copilot. Настройка только показывается.' }
    StartupTitle = @{ EN = 'Copilot startup'; HU = 'Copilot automatikus inditasa'; UK = 'Автозапуск Copilot'; RU = 'Автозагрузка Copilot' }
    StartupNone = @{ EN = 'No startup entries named Copilot were found.'; HU = 'Nem talalhato Copilot nevu automatikus inditasi bejegyzes.'; UK = 'Записів автозапуску з назвою Copilot не знайдено.'; RU = 'Записи автозагрузки с именем Copilot не найдены.' }
    StartupDetails = @{ EN = 'Checks Run/RunOnce, Startup folders, and scheduled tasks. Matches are reported only; MaruPilot does not disable or remove startup entries.'; HU = 'Ellenorzi a Run/RunOnce bejegyzeseket, az Inditopult mappakat es az utemezett feladatokat. A talalatokat csak megjeleniti; nem tiltja le es nem torli oket.'; UK = 'Перевіряє Run/RunOnce, папки автозавантаження та завдання планувальника. Збіги лише показуються; MaruPilot їх не вимикає і не видаляє.'; RU = 'Проверяются Run/RunOnce, папки автозагрузки и задания планировщика. Совпадения только показываются; MaruPilot их не отключает и не удаляет.' }
    OfficeTitle = @{ EN = 'Microsoft 365 Copilot (Word, Excel, PowerPoint, etc.)'; HU = 'Microsoft 365 Copilot (Word, Excel, PowerPoint stb.)'; UK = 'Microsoft 365 Copilot (Word, Excel, PowerPoint тощо)'; RU = 'Microsoft 365 Copilot (Word, Excel, PowerPoint и другие)' }
    OfficeDetails = @{ EN = 'A universal local policy for all Microsoft 365 apps is not confirmed here. Availability depends on the app, license, and organization management. MaruPilot does not alter Office or guess registry settings.'; HU = 'Itt nem igazolhato minden Microsoft 365 alkalmazasra ervenyes helyi hazirend. Az elerhetoseg az alkalmazastol, licenctol es szervezeti felugyelettol fugg. A MaruPilot nem modositja az Office-t.'; UK = 'Універсальну локальну політику для всіх програм Microsoft 365 тут не підтверджено. Доступність залежить від програми, ліцензії та керування організацією. MaruPilot не змінює Office.'; RU = 'Универсальная локальная политика для всех приложений Microsoft 365 здесь не подтверждена. Доступность зависит от приложения, лицензии и управления организацией. MaruPilot не меняет Office.' }
    HardwareTitle = @{ EN = 'Copilot+ hardware'; HU = 'Copilot+ hardver'; UK = 'Обладнання Copilot+'; RU = 'Оборудование Copilot+' }
    HardwareDetails = @{ EN = 'An NPU name check is only indicative; Copilot+ certification and TOPS cannot be reliably determined this way. Hardware and drivers are not changed.'; HU = 'Az NPU-nev ellenorzese csak tajekoztato jellegu; a Copilot+ tanusitas es a TOPS-ertek igy nem allapithato meg megbizhatoan. A hardver es az illesztoprogramok nem valtoznak.'; UK = 'Перевірка назви NPU лише орієнтовна; сертифікацію Copilot+ і TOPS так надійно не визначити. Обладнання та драйвери не змінюються.'; RU = 'Проверка имени NPU лишь ориентировочная; сертификацию Copilot+ и TOPS так надёжно не определить. Оборудование и драйверы не меняются.' }
    RecallTitle = @{ EN = 'Copilot+ / Recall and Windows AI'; HU = 'Copilot+ / Recall es Windows AI'; UK = 'Copilot+ / Recall і Windows AI'; RU = 'Copilot+ / Recall и Windows AI' }
    RecallDetails = @{ EN = 'Recall depends on Windows edition and hardware. Its policies are not changed because some can delete saved snapshots. Defender, Windows Update, and shared Windows components are untouched.'; HU = 'A Recall a Windows-kiadastol es hardvertol fugg. Hazirendjei nem valtoznak, mert egyes beallitasok torolhetik a mentett pillanatkepeket. A Defender, a Windows Update es a kozos Windows-osszetevok erintetlenek.'; UK = 'Recall залежить від редакції Windows і обладнання. Його політики не змінюються, оскільки деякі можуть видалити збережені знімки. Defender, Windows Update та спільні компоненти Windows не зачіпаються.'; RU = 'Recall зависит от редакции Windows и оборудования. Его политики не меняются, поскольку некоторые могут удалить сохранённые снимки. Defender, Windows Update и общие компоненты Windows не затрагиваются.' }
    ConfirmTitle = @{ EN = 'Review and confirm changes'; HU = 'Valtozasok attekintese es megerositese'; UK = 'Перегляд і підтвердження змін'; RU = 'Проверка и подтверждение изменений' }
    ConfirmInstruction = @{ EN = 'Select policies to apply. Current values are backed up first for rollback.'; HU = 'Valassza ki az alkalmazando hazirendeket. A visszaallitashoz elmentjuk a jelenlegi ertekeket.'; UK = 'Виберіть політики. Перед застосуванням буде збережено поточні значення для відновлення.'; RU = 'Выберите политики. Перед применением будут сохранены текущие значения для восстановления.' }
    ConfirmDisclosure = @{ EN = 'Administrator rights are required. Disabling the entire Edge sidebar also hides other apps. Office, the new Copilot app, and Copilot+ are not changed. Right-click the main window to restore.'; HU = 'Rendszergazdai jogosultsag szukseges. A teljes Edge oldalsav kikapcsolasa mas alkalmazasokat is elrejt. Az Office, az uj Copilot alkalmazas es a Copilot+ nem valtozik. Visszaallitas a foablak jobb gombos menujebol.'; UK = 'Потрібні права адміністратора. Вимкнення всієї бічної панелі Edge також приховає інші програми. Office, новий Copilot і Copilot+ не змінюються. Для відновлення відкрийте контекстне меню.'; RU = 'Требуются права администратора. Отключение всей боковой панели Edge также скроет другие приложения. Office, новое приложение Copilot и Copilot+ не меняются. Для восстановления откройте контекстное меню.' }
    Apply = @{ EN = 'Apply selected'; HU = 'Kivalasztottak alkalmazasa'; UK = 'Застосувати вибране'; RU = 'Применить выбранное' }
    Cancel = @{ EN = 'Cancel'; HU = 'Megse'; UK = 'Скасувати'; RU = 'Отмена' }
    ResultApplyTitle = @{ EN = 'MaruPilot - apply results'; HU = 'MaruPilot - alkalmazasi eredmeny'; UK = 'MaruPilot — результат застосування'; RU = 'MaruPilot — результат применения' }
    ResultRestoreTitle = @{ EN = 'MaruPilot - restore results'; HU = 'MaruPilot - visszaallitasi eredmeny'; UK = 'MaruPilot — результат відновлення'; RU = 'MaruPilot — результат восстановления' }
    ResultApplied = @{ EN = '{0}: policy applied.'; HU = '{0}: a hazirend alkalmazva.'; UK = '{0}: політику застосовано.'; RU = '{0}: политика применена.' }
    ResultAlready = @{ EN = '{0}: already configured; unchanged.'; HU = '{0}: mar be van allitva; nem valtozott.'; UK = '{0}: уже налаштовано; без змін.'; RU = '{0}: уже настроено; значение не изменено.' }
    RestoreNone = @{ EN = 'MaruPilot has no saved changes to restore. Existing third-party policies are left untouched.'; HU = 'A MaruPilot nem mentett el visszaallithato modositasokat. A mas forrasbol szarmazo hazirendek erintetlenek maradnak.'; UK = 'MaruPilot не має збережених змін для відновлення. Сторонні політики не змінюються.'; RU = 'MaruPilot не сохранял изменений для восстановления. Сторонние политики не изменяются.' }
    RestoreConfirmIntro = @{ EN = 'Only changes saved by MaruPilot will be reverted:'; HU = 'Csak a MaruPilot altal mentett modositasok allnak vissza:'; UK = 'Буде скасовано лише зміни, збережені MaruPilot:'; RU = 'Будут отменены только изменения, сохранённые MaruPilot:' }
    RestoreAdmin = @{ EN = 'Administrator rights are required. You can apply the policies again later.'; HU = 'A visszaallitashoz rendszergazdai jogosultsag kell. Kesobb ujra alkalmazhatja a hazirendeket.'; UK = 'Для відновлення потрібні права адміністратора. Пізніше політики можна застосувати знову.'; RU = 'Для восстановления требуются права администратора. Позже политики можно применить снова.' }
    RestoreQuestion = @{ EN = 'Continue restoring?'; HU = 'Folytatja a visszaallitast?'; UK = 'Продовжити відновлення?'; RU = 'Продолжить восстановление?' }
    RestoreTitle = @{ EN = 'MaruPilot - confirm restore'; HU = 'MaruPilot - visszaallitas megerositese'; UK = 'MaruPilot — підтвердження відновлення'; RU = 'MaruPilot — подтверждение восстановления' }
    RestoreAlready = @{ EN = '{0}: already restored.'; HU = '{0}: mar visszaallitva.'; UK = '{0}: вже відновлено.'; RU = '{0}: уже восстановлено.' }
    RestoreDone = @{ EN = '{0}: previous state restored.'; HU = '{0}: elozo allapot visszaallitva.'; UK = '{0}: попередній стан відновлено.'; RU = '{0}: предыдущее состояние восстановлено.' }
    RestoreExternal = @{ EN = '{0}: skipped; changed outside MaruPilot. External value preserved.'; HU = '{0}: kihagyva; a MaruPiloton kivul megvaltozott. A kulso ertek megmarad.'; UK = '{0}: пропущено — налаштування змінили поза MaruPilot; зовнішнє значення збережено.'; RU = '{0}: пропущено — настройка изменилась вне MaruPilot; внешнее значение сохранено.' }
    LogTitle = @{ EN = 'MaruPilot - change log'; HU = 'MaruPilot - valtozasi naplo'; UK = 'MaruPilot — журнал змін'; RU = 'MaruPilot — журнал изменений' }
    LogEmpty = @{ EN = 'The log is empty. Checks and changes are recorded in %APPDATA%\MaruPilot\changes.log.'; HU = 'A naplo ures. Az ellenorzesek es modositasok helye: %APPDATA%\MaruPilot\changes.log.'; UK = 'Журнал порожній. Перевірки та зміни записуються в %APPDATA%\MaruPilot\changes.log.'; RU = 'Журнал пока пуст. Проверки и изменения записываются в %APPDATA%\MaruPilot\changes.log.' }
    ErrorTitle = @{ EN = 'MaruPilot error'; HU = 'MaruPilot hiba'; UK = 'Помилка MaruPilot'; RU = 'Ошибка MaruPilot' }
    ChannelError = @{ EN = 'Could not open YouTube channel: {0}'; HU = 'A YouTube-csatorna nem nyithato meg: {0}'; UK = 'Не вдалося відкрити канал YouTube: {0}'; RU = 'Не удалось открыть YouTube-канал: {0}' }
    LanguageSaveError = @{ EN = 'Could not save the selected language: {0}'; HU = 'A kivalasztott nyelv nem mentheto: {0}'; UK = 'Не вдалося зберегти вибрану мову: {0}'; RU = 'Не удалось сохранить выбранный язык: {0}' }
    SettingsReadError = @{ EN = 'Could not read settings: {0}'; HU = 'A beallitasok nem olvashatok: {0}'; UK = 'Не вдалося прочитати налаштування: {0}'; RU = 'Не удалось прочитать настройки: {0}' }
    CurrentValueLabel = @{ EN = 'Current:'; HU = 'Jelenlegi:'; UK = 'Поточне:'; RU = 'Текущее:' }
    AuditDialogTitle = @{ EN = 'MaruPilot - system check'; HU = 'MaruPilot - rendszerellenorzes'; UK = 'MaruPilot — перевірка системи'; RU = 'MaruPilot — проверка системы' }
    LogWriteError = @{ EN = 'Could not write to the log: {0}'; HU = 'A naplo nem irhato: {0}'; UK = 'Не вдалося записати в журнал: {0}'; RU = 'Не удалось записать в журнал: {0}' }
    LogOpenError = @{ EN = 'Could not open the change log: {0}'; HU = 'A valtozasi naplo nem nyithato meg: {0}'; UK = 'Не вдалося відкрити журнал змін: {0}'; RU = 'Не удалось открыть журнал изменений: {0}' }
    DeviceAlready = @{ EN = '{0}: already disabled by a device policy; no user policy was added.'; HU = '{0}: eszkoz-hazirend mar letiltotta; felhasznaloi hazirend nem keszult.'; UK = '{0}: уже вимкнено політикою пристрою; користувацьку політику не додано.'; RU = '{0}: уже отключено политикой устройства; пользовательская настройка не добавлена.' }
    DeviceConflict = @{ EN = '{0}: skipped; device policy has value {1} and was not overwritten.'; HU = '{0}: kihagyva; az eszkoz-hazirend {1} erteke nem lett felulirva.'; UK = '{0}: пропущено — політику пристрою зі значенням {1} не перезаписано.'; RU = '{0}: пропущено — политика устройства со значением {1} не перезаписана.' }
    ResultExternal = @{ EN = '{0}: skipped; another source already set the value. It was not overwritten.'; HU = '{0}: kihagyva; mas forras mar beallitotta. Nem lett felulirva.'; UK = '{0}: пропущено — значення вже встановлено іншим джерелом; його не перезаписано.'; RU = '{0}: пропущено — значение уже установлено другим источником; оно не перезаписано.' }
    ResultPending = @{ EN = '{0}: skipped; awaiting restoration of an earlier change.'; HU = '{0}: kihagyva; korabbi modositas visszaallitasa szukseges.'; UK = '{0}: пропущено — очікує відновлення попереднього параметра.'; RU = '{0}: пропущено — ожидает восстановления прежней настройки.' }
    RestoreDelete = @{ EN = '{0}: remove the policy value created by MaruPilot.'; HU = '{0}: a MaruPilot altal letrehozott ertek torlese.'; UK = '{0}: видалити значення політики, створене MaruPilot.'; RU = '{0}: удалить созданное MaruPilot значение политики.' }
    ApplyFailure = @{ EN = 'Could not change {0}: {1}'; HU = '{0} nem modosithato: {1}'; UK = 'Не вдалося змінити {0}: {1}'; RU = 'Не удалось изменить {0}: {1}' }
    RestoreFailure = @{ EN = 'Could not restore {0}: {1}'; HU = '{0} nem allithato vissza: {1}'; UK = 'Не вдалося відновити {0}: {1}'; RU = 'Не удалось восстановить {0}: {1}' }
    VerifyApplyError = @{ EN = 'The policy did not confirm the expected value after writing; the backup was preserved.'; HU = 'A hazirend nem igazolta a vart erteket; a biztonsagi mentes megmaradt.'; UK = 'Після запису політика не підтвердила очікуване значення; резервну копію збережено.'; RU = 'После записи политика не подтвердила ожидаемое значение; резервная копия сохранена.' }
    VerifyRestoreError = @{ EN = 'The restored value did not match the backup; the saved state was retained.'; HU = 'A visszaallitott ertek nem egyezik a mentessel; a mentett allapot megmaradt.'; UK = 'Відновлене значення не збіглося з резервною копією; збережений стан залишено.'; RU = 'После восстановления значение не совпало с резервной копией; сохранённое состояние оставлено.' }
    RestoreValue = @{ EN = '{0}: restore previous value {1} ({2}).'; HU = '{0}: korabbi ertek visszaallitasa: {1} ({2}).'; UK = '{0}: відновити попереднє значення {1} ({2}).'; RU = '{0}: восстановить прежнее значение {1} ({2}).' }
    ValueNotConfigured = @{ EN = 'not configured'; HU = 'nincs beallitva'; UK = 'не налаштовано'; RU = 'не задано' }
}

function T {
    param([string]$Key)

    $entry = $script:strings[$Key]
    if ($null -eq $entry) {
        return "[$Key]"
    }
    return $entry[$script:currentLanguage]
}

function Get-LocalizedPolicyText {
    param(
        [pscustomobject]$Definition,
        [ValidateSet('Title', 'Description', 'ShortDescription')]
        [string]$Property
    )

    $prefix = switch ($Definition.Id) {
        'WindowsClassic' { 'PolicyWindows' }
        'EdgeCopilotIcon' { 'PolicyEdge' }
        'EdgeSidebar' { 'PolicySidebar' }
        default { return $Definition.$Property }
    }
    $suffix = switch ($Property) {
        'Title' { 'Title' }
        'Description' { 'Details' }
        'ShortDescription' { 'Short' }
    }
    return (T "$prefix$suffix")
}

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
$isAdministrator = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$policyDefinitions = @(
    [pscustomobject]@{
        Id = 'WindowsClassic'
        Title = 'Классический Windows Copilot'
        Key = 'Software\Policies\Microsoft\Windows\WindowsCopilot'
        Name = 'TurnOffWindowsCopilot'
        DisabledValue = 1
        CheckMachine = $false
        Description = 'Отключает классическую панель Windows Copilot. Официальная политика устарела и не блокирует новое приложение Copilot.'
        ShortDescription = 'Включить официальную политику TurnOffWindowsCopilot.'
    },
    [pscustomobject]@{
        Id = 'EdgeCopilotIcon'
        Title = 'Кнопка Microsoft 365 Copilot Chat в Edge'
        Key = 'Software\Policies\Microsoft\Edge'
        Name = 'Microsoft365CopilotChatIconEnabled'
        DisabledValue = 0
        CheckMachine = $true
        Description = 'Скрывает кнопку Copilot Chat в панели Edge for Business для профилей Entra ID в Edge 139+. Не отключает Copilot на сайтах или в других профилях.'
        ShortDescription = 'Скрыть кнопку Copilot Chat в поддерживаемых профилях Edge.'
    },
    [pscustomobject]@{
        Id = 'EdgeSidebar'
        Title = 'Вся боковая панель Microsoft Edge'
        Key = 'Software\Policies\Microsoft\Edge'
        Name = 'HubsSidebarEnabled'
        DisabledValue = 0
        CheckMachine = $true
        Description = 'Скрывает всю боковую панель Edge, включая приложения и функции, не относящиеся к Copilot.'
        ShortDescription = 'Необязательно: выключить всю боковую панель Edge, включая другие приложения.'
    }
)

function Save-Config {
    if (-not (Test-Path -LiteralPath $appDirectory)) {
        New-Item -ItemType Directory -Path $appDirectory -Force | Out-Null
    }

    $config | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $configPath -Encoding UTF8
}

function Write-ChangeLog {
    param([string]$Message)

    if (-not (Test-Path -LiteralPath $appDirectory)) {
        New-Item -ItemType Directory -Path $appDirectory -Force | Out-Null
    }

    $entry = '{0}  {1}{2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Message, [Environment]::NewLine
    [System.IO.File]::AppendAllText($logPath, $entry, (New-Object System.Text.UTF8Encoding($true)))
}

function Get-RegistryHive {
    param([string]$Hive)

    if ($Hive -eq 'LocalMachine') {
        return [Microsoft.Win32.Registry]::LocalMachine
    }
    return [Microsoft.Win32.Registry]::CurrentUser
}

function Read-RegistryValue {
    param(
        [string]$KeyPath,
        [string]$Name,
        [ValidateSet('CurrentUser', 'LocalMachine')]
        [string]$Hive = 'CurrentUser'
    )

    $baseKey = Get-RegistryHive -Hive $Hive
    $key = $baseKey.OpenSubKey($KeyPath, $false)
    if ($null -eq $key) {
        return [pscustomobject]@{
            Exists = $false
            Value = $null
            Kind = 'DWord'
        }
    }

    try {
        $value = $key.GetValue($Name, $null)
        if ($null -eq $value) {
            return [pscustomobject]@{
                Exists = $false
                Value = $null
                Kind = 'DWord'
            }
        }

        return [pscustomobject]@{
            Exists = $true
            Value = $value
            Kind = $key.GetValueKind($Name).ToString()
        }
    }
    finally {
        $key.Dispose()
    }
}

function Set-RegistryValue {
    param(
        [string]$KeyPath,
        [string]$Name,
        [object]$Value,
        [Microsoft.Win32.RegistryValueKind]$Kind,
        [ValidateSet('CurrentUser', 'LocalMachine')]
        [string]$Hive = 'CurrentUser'
    )

    $key = (Get-RegistryHive -Hive $Hive).CreateSubKey($KeyPath)
    if ($null -eq $key) {
        throw "Windows не разрешил создать раздел реестра $Hive\$KeyPath."
    }

    try {
        $key.SetValue($Name, $Value, $Kind)
    }
    finally {
        $key.Dispose()
    }
}

function Remove-RegistryValue {
    param(
        [string]$KeyPath,
        [string]$Name,
        [ValidateSet('CurrentUser', 'LocalMachine')]
        [string]$Hive = 'CurrentUser'
    )

    $key = (Get-RegistryHive -Hive $Hive).OpenSubKey($KeyPath, $true)
    if ($null -eq $key) {
        return
    }

    try {
        $key.DeleteValue($Name, $false)
    }
    finally {
        $key.Dispose()
    }
}

function Get-PolicyValueText {
    param(
        [pscustomobject]$Definition,
        [string]$Hive = 'CurrentUser'
    )

    $snapshot = Read-RegistryValue -KeyPath $Definition.Key -Name $Definition.Name -Hive $Hive
    $machineText = ''
    if ($Hive -eq 'CurrentUser' -and $Definition.CheckMachine) {
        $machine = Read-RegistryValue -KeyPath $Definition.Key -Name $Definition.Name -Hive 'LocalMachine'
        if ($machine.Exists) {
            if ($machine.Kind -eq 'DWord' -and [int]$machine.Value -eq [int]$Definition.DisabledValue) {
                $machineText = T 'DeviceDisabled'
            }
            else {
                $machineText = (T 'DeviceValue') -f $machine.Value, $machine.Kind
            }
        }
    }
    if (-not $snapshot.Exists) {
        return "$(T 'UserNotConfigured')$machineText"
    }
    if ($snapshot.Kind -ne 'DWord') {
        return "$((T 'PolicyUnexpected') -f $snapshot.Kind, $snapshot.Value)$machineText"
    }
    if ([int]$snapshot.Value -eq [int]$Definition.DisabledValue) {
        return "$(T 'PolicyEnabled')$machineText"
    }
    return "$((T 'PolicyValue') -f $snapshot.Value)$machineText"
}

function Get-StartupFindings {
    $findings = New-Object System.Collections.Generic.List[string]
    $runKeys = @(
        @{ Hive = 'CurrentUser'; Path = 'Software\Microsoft\Windows\CurrentVersion\Run' },
        @{ Hive = 'CurrentUser'; Path = 'Software\Microsoft\Windows\CurrentVersion\RunOnce' },
        @{ Hive = 'LocalMachine'; Path = 'Software\Microsoft\Windows\CurrentVersion\Run' },
        @{ Hive = 'LocalMachine'; Path = 'Software\Microsoft\Windows\CurrentVersion\RunOnce' }
    )

    foreach ($entry in $runKeys) {
        $key = (Get-RegistryHive -Hive $entry.Hive).OpenSubKey($entry.Path, $false)
        if ($null -eq $key) {
            continue
        }

        try {
            foreach ($valueName in $key.GetValueNames()) {
                $value = [string]$key.GetValue($valueName, '')
                if ($valueName -match '(?i)copilot' -or $value -match '(?i)copilot') {
                    $findings.Add("$($entry.Hive) Run: $valueName")
                }
            }
        }
        finally {
            $key.Dispose()
        }
    }

    $startupFolders = @(
        [Environment]::GetFolderPath([Environment+SpecialFolder]::Startup),
        [Environment]::GetFolderPath([Environment+SpecialFolder]::CommonStartup)
    )
    foreach ($folder in $startupFolders) {
        if (-not [string]::IsNullOrWhiteSpace($folder) -and (Test-Path -LiteralPath $folder)) {
            foreach ($file in Get-ChildItem -LiteralPath $folder -File -ErrorAction Stop) {
                if ($file.Name -match '(?i)copilot') {
                    $findings.Add(((T 'StartupFolder') -f $file.Name))
                }
            }
        }
    }

    try {
        $tasks = @(Get-ScheduledTask -ErrorAction Stop | Where-Object {
            $_.TaskName -match '(?i)copilot' -or
            $_.Actions.Execute -match '(?i)copilot' -or
            $_.Actions.Arguments -match '(?i)copilot'
        })
        foreach ($task in $tasks) {
            $findings.Add(((T 'ScheduledTask') -f "$($task.TaskPath)$($task.TaskName)"))
        }
    }
    catch {
        $findings.Add(((T 'TaskError') -f $_.Exception.Message))
    }

    return @($findings.ToArray())
}

function Get-InstalledOfficeProducts {
    $configuration = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SOFTWARE\Microsoft\Office\ClickToRun\Configuration', $false)
    if ($null -eq $configuration) {
        return T 'OfficeNone'
    }

    try {
        $productIds = [string]$configuration.GetValue('ProductReleaseIds', '')
        if ([string]::IsNullOrWhiteSpace($productIds)) {
            return T 'OfficeUnknown'
        }
        return ((T 'OfficeFound') -f $productIds)
    }
    finally {
        $configuration.Dispose()
    }
}

function Get-CopilotPackages {
    try {
        $packages = @(Get-AppxPackage -Name '*Copilot*' -ErrorAction Stop)
        $processes = @(Get-Process -Name '*Copilot*' -ErrorAction Stop)
        $packageText = if ($packages.Count -eq 0) {
            T 'PackageNone'
        }
        else {
            (T 'PackagesLabel') + ': ' + (($packages | ForEach-Object { $_.Name }) -join ', ')
        }
        $processText = if ($processes.Count -eq 0) {
            T 'ProcessNone'
        }
        else {
            (T 'ProcessesLabel') + ': ' + (($processes | ForEach-Object { $_.ProcessName }) -join ', ')
        }
        return ((T 'Detection') -f $packageText, $processText)
    }
    catch {
        return ((T 'DetectionError') -f $_.Exception.Message)
    }
}

function Get-CopilotHardwareKeyStatus {
    $snapshot = Read-RegistryValue -KeyPath 'Software\Policies\Microsoft\Windows\CopilotKey' -Name 'SetCopilotHardwareKey'
    if (-not $snapshot.Exists) {
        return T 'KeyUnset'
    }
    return ((T 'KeySet') -f $snapshot.Value, $snapshot.Kind)
}

function Get-CopilotRemovalPolicyStatus {
    $path = 'Software\Policies\Microsoft\Windows\WindowsAI'
    $userPolicy = Read-RegistryValue -KeyPath $path -Name 'RemoveMicrosoftCopilotApp' -Hive 'CurrentUser'
    $devicePolicy = Read-RegistryValue -KeyPath $path -Name 'RemoveMicrosoftCopilotApp' -Hive 'LocalMachine'
    $userText = if ($userPolicy.Exists) { $userPolicy.Value } else { T 'ValueNotConfigured' }
    $deviceText = if ($devicePolicy.Exists) { $devicePolicy.Value } else { T 'ValueNotConfigured' }
    return ((T 'RemovalStatus') -f $userText, $deviceText)
}

function Get-RecallPolicies {
    $windowsAI = 'Software\Policies\Microsoft\Windows\WindowsAI'
    $allowUser = Read-RegistryValue -KeyPath $windowsAI -Name 'AllowRecallEnablement' -Hive 'CurrentUser'
    $allowDevice = Read-RegistryValue -KeyPath $windowsAI -Name 'AllowRecallEnablement' -Hive 'LocalMachine'
    $analysisUser = Read-RegistryValue -KeyPath $windowsAI -Name 'DisableAIDataAnalysis' -Hive 'CurrentUser'
    $analysisDevice = Read-RegistryValue -KeyPath $windowsAI -Name 'DisableAIDataAnalysis' -Hive 'LocalMachine'

    return ((T 'RecallStatus') -f `
        $(if ($allowUser.Exists) { $allowUser.Value } else { T 'ValueNotConfigured' }), `
        $(if ($allowDevice.Exists) { $allowDevice.Value } else { T 'ValueNotConfigured' }), `
        $(if ($analysisUser.Exists) { $analysisUser.Value } else { T 'ValueNotConfigured' }), `
        $(if ($analysisDevice.Exists) { $analysisDevice.Value } else { T 'ValueNotConfigured' }))
}

function Get-CopilotPlusHardwareStatus {
    try {
        $devices = @(Get-CimInstance -ClassName Win32_PnPEntity -Filter "Name LIKE '%NPU%' OR Name LIKE '%Neural Processing%' OR Name LIKE '%AI Boost%'" -ErrorAction Stop |
            Where-Object { $_.Name -match '(?i)\bNPU\b|Neural Processing|AI Boost' })
        if ($devices.Count -eq 0) {
            return T 'NoNpu'
        }
        return ((T 'NpuFound') -f (($devices | ForEach-Object { $_.Name }) -join '; '))
    }
    catch {
        return ((T 'NpuError') -f $_.Exception.Message)
    }
}

function Get-AuditRows {
    $rows = New-Object System.Collections.Generic.List[object]

    foreach ($definition in $policyDefinitions) {
        try {
            $state = Get-PolicyValueText -Definition $definition
            $rows.Add([pscustomobject]@{
                Component = Get-LocalizedPolicyText -Definition $definition -Property Title
                Status = $state
                Details = Get-LocalizedPolicyText -Definition $definition -Property Description
            })
        }
        catch {
            $rows.Add([pscustomobject]@{
                Component = Get-LocalizedPolicyText -Definition $definition -Property Title
                Status = (T 'PolicyFailure') -f $_.Exception.Message
                Details = Get-LocalizedPolicyText -Definition $definition -Property Description
            })
        }
    }

    $rows.Add([pscustomobject]@{
        Component = T 'NewAppTitle'
        Status = Get-CopilotPackages
        Details = T 'NewAppDetails'
    })
    $removalPolicyStatus = try {
        Get-CopilotRemovalPolicyStatus
    }
    catch {
        (T 'PolicyFailure') -f $_.Exception.Message
    }
    $rows.Add([pscustomobject]@{
        Component = T 'RemovalTitle'
        Status = $removalPolicyStatus
        Details = T 'RemovalDetails'
    })
    $hardwareKeyStatus = try {
        Get-CopilotHardwareKeyStatus
    }
    catch {
        (T 'PolicyFailure') -f $_.Exception.Message
    }
    $rows.Add([pscustomobject]@{
        Component = T 'KeyTitle'
        Status = $hardwareKeyStatus
        Details = T 'KeyDetails'
    })

    try {
        $startup = @(Get-StartupFindings)
        $startupStatus = if ($startup.Count -eq 0) {
            T 'StartupNone'
        }
        else {
            $startup -join '; '
        }
        $rows.Add([pscustomobject]@{
            Component = T 'StartupTitle'
            Status = $startupStatus
            Details = T 'StartupDetails'
        })
    }
    catch {
        $rows.Add([pscustomobject]@{
            Component = T 'StartupTitle'
            Status = (T 'PolicyFailure') -f $_.Exception.Message
            Details = T 'StartupDetails'
        })
    }

    try {
        $rows.Add([pscustomobject]@{
            Component = T 'OfficeTitle'
            Status = Get-InstalledOfficeProducts
            Details = T 'OfficeDetails'
        })
    }
    catch {
        $rows.Add([pscustomobject]@{
            Component = T 'OfficeTitle'
            Status = (T 'PolicyFailure') -f $_.Exception.Message
            Details = T 'OfficeDetails'
        })
    }

    try {
        $rows.Add([pscustomobject]@{
            Component = T 'HardwareTitle'
            Status = Get-CopilotPlusHardwareStatus
            Details = T 'HardwareDetails'
        })
    }
    catch {
        $rows.Add([pscustomobject]@{
            Component = T 'HardwareTitle'
            Status = (T 'PolicyFailure') -f $_.Exception.Message
            Details = T 'HardwareDetails'
        })
    }

    try {
        $rows.Add([pscustomobject]@{
            Component = T 'RecallTitle'
            Status = Get-RecallPolicies
            Details = T 'RecallDetails'
        })
    }
    catch {
        $rows.Add([pscustomobject]@{
            Component = T 'RecallTitle'
            Status = (T 'PolicyFailure') -f $_.Exception.Message
            Details = T 'RecallDetails'
        })
    }

    return @($rows.ToArray())
}

function Format-AuditReport {
    param([object[]]$Rows)

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add((T 'AuditTitle'))
    $lines.Add(((T 'DatePrefix') -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')))
    $lines.Add('')
    foreach ($row in $Rows) {
        $lines.Add("[$($row.Component)]")
        $lines.Add(((T 'StatePrefix') -f $row.Status))
        $lines.Add(((T 'DetailsPrefix') -f $row.Details))
        $lines.Add('')
    }
    $lines.Add((T 'AuditFooter'))
    return $lines -join [Environment]::NewLine
}

function Show-TextDialog {
    param(
        [string]$Title,
        [string]$Text
    )

    $dialog = New-Object System.Windows.Forms.Form
    $dialog.Text = $Title
    $dialog.StartPosition = 'CenterParent'
    $dialog.Size = New-Object System.Drawing.Size(760, 560)
    $dialog.MinimumSize = New-Object System.Drawing.Size(600, 400)
    $dialog.Font = $form.Font

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Multiline = $true
    $textBox.ReadOnly = $true
    $textBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
    $textBox.WordWrap = $false
    $textBox.Dock = [System.Windows.Forms.DockStyle]::Fill
    $textBox.Font = New-Object System.Drawing.Font('Consolas', 9)
    $textBox.Text = $Text
    $dialog.Controls.Add($textBox)
    [void]$dialog.ShowDialog($form)
    $dialog.Dispose()
}

function Get-BackupCount {
    return $config.PolicyBackups.Count
}

function Test-RegistryValueMatchesBackup {
    param(
        [pscustomobject]$Snapshot,
        [object]$Backup
    )

    if (-not $Snapshot.Exists) {
        return (-not $Backup.Exists)
    }

    if (-not $Backup.Exists -or $Snapshot.Kind -ne $Backup.Kind) {
        return $false
    }

    return ([string]$Snapshot.Value -ceq [string]$Backup.Value)
}

function Update-Status {
    try {
        $configuredCount = 0
        foreach ($definition in $policyDefinitions) {
            $snapshot = Read-RegistryValue -KeyPath $definition.Key -Name $definition.Name
            if ($snapshot.Exists -and $snapshot.Kind -eq 'DWord' -and [int]$snapshot.Value -eq [int]$definition.DisabledValue) {
                $configuredCount++
                continue
            }

            if ($definition.CheckMachine) {
                $machine = Read-RegistryValue -KeyPath $definition.Key -Name $definition.Name -Hive 'LocalMachine'
                if ($machine.Exists -and $machine.Kind -eq 'DWord' -and [int]$machine.Value -eq [int]$definition.DisabledValue) {
                    $configuredCount++
                }
            }
        }

        if ($configuredCount -gt 0) {
            $statusLabel.Text = (T 'StatusCount') -f $configuredCount
            $statusLabel.ForeColor = [System.Drawing.Color]::Firebrick
        }
        else {
            $statusLabel.Text = T 'StatusNone'
            $statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
        }

        if ((Get-BackupCount) -gt 0) {
            $toggleButton.Text = T 'ButtonRestore'
        }
        else {
            $toggleButton.Text = T 'ButtonBlock'
        }
    }
    catch {
        $statusLabel.Text = (T 'StatusError') -f $_.Exception.Message
        $statusLabel.ForeColor = [System.Drawing.Color]::Firebrick
        $toggleButton.Text = T 'ButtonCheck'
    }
}

function Show-SystemAudit {
    try {
        $rows = Get-AuditRows
        Write-ChangeLog 'Проверка системы: аудит Copilot выполнен.'
        Show-TextDialog -Title (T 'AuditDialogTitle') -Text (Format-AuditReport -Rows $rows)
    }
    catch {
        Show-ErrorDialog -Message ((T 'AuditFailure') -f $_.Exception.Message)
    }
}

function Show-ErrorDialog {
    param([string]$Message)

    try {
        Write-ChangeLog "ОШИБКА: $Message"
    }
    catch {
        $Message = "$Message`r`n$((T 'LogWriteError') -f $_.Exception.Message)"
    }

    [System.Windows.Forms.MessageBox]::Show(
        $Message,
        (T 'ErrorTitle'),
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    ) | Out-Null
}

function Show-BlockConfirmation {
    param([object[]]$Rows)

    $dialog = New-Object System.Windows.Forms.Form
    $dialog.Text = T 'ConfirmTitle'
    $dialog.StartPosition = 'CenterParent'
    $dialog.Size = New-Object System.Drawing.Size(760, 610)
    $dialog.MinimumSize = New-Object System.Drawing.Size(650, 500)
    $dialog.Font = $form.Font

    $auditBox = New-Object System.Windows.Forms.TextBox
    $auditBox.Location = New-Object System.Drawing.Point(12, 12)
    $auditBox.Size = New-Object System.Drawing.Size(720, 280)
    $auditBox.Anchor = 'Top, Left, Right'
    $auditBox.Multiline = $true
    $auditBox.ReadOnly = $true
    $auditBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
    $auditBox.Font = New-Object System.Drawing.Font('Consolas', 8)
    $auditBox.Text = Format-AuditReport -Rows $Rows
    $dialog.Controls.Add($auditBox)

    $instruction = New-Object System.Windows.Forms.Label
    $instruction.Text = T 'ConfirmInstruction'
    $instruction.Location = New-Object System.Drawing.Point(12, 302)
    $instruction.Size = New-Object System.Drawing.Size(720, 24)
    $instruction.Anchor = 'Top, Left, Right'
    $dialog.Controls.Add($instruction)

    $policyList = New-Object System.Windows.Forms.CheckedListBox
    $policyList.Location = New-Object System.Drawing.Point(12, 332)
    $policyList.Size = New-Object System.Drawing.Size(720, 135)
    $policyList.Anchor = 'Top, Left, Right'
    $policyList.CheckOnClick = $true
    foreach ($definition in $policyDefinitions) {
        $current = Get-PolicyValueText -Definition $definition
        $localizedTitle = Get-LocalizedPolicyText -Definition $definition -Property Title
        $localizedShort = Get-LocalizedPolicyText -Definition $definition -Property ShortDescription
        $itemText = "$localizedTitle — $localizedShort $(T 'CurrentValueLabel') $current"
        $index = $policyList.Items.Add($itemText)
        $policyList.SetItemChecked($index, ($definition.Id -ne 'EdgeSidebar'))
    }
    $dialog.Controls.Add($policyList)

    $disclosure = New-Object System.Windows.Forms.Label
    $disclosure.Text = T 'ConfirmDisclosure'
    $disclosure.Location = New-Object System.Drawing.Point(12, 478)
    $disclosure.Size = New-Object System.Drawing.Size(720, 48)
    $disclosure.Anchor = 'Top, Left, Right'
    $disclosure.ForeColor = [System.Drawing.Color]::DimGray
    $dialog.Controls.Add($disclosure)

    $applyButton = New-Object System.Windows.Forms.Button
    $applyButton.Text = T 'Apply'
    $applyButton.Location = New-Object System.Drawing.Point(432, 535)
    $applyButton.Size = New-Object System.Drawing.Size(180, 34)
    $applyButton.Anchor = 'Bottom, Right'
    $applyButton.Add_Click({
        $selected = New-Object System.Collections.Generic.List[string]
        for ($index = 0; $index -lt $policyList.Items.Count; $index++) {
            if ($policyList.GetItemChecked($index)) {
                $selected.Add($policyDefinitions[$index].Id)
            }
        }
        $dialog.Tag = @($selected.ToArray())
        $dialog.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $dialog.Close()
    })
    $dialog.Controls.Add($applyButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = T 'Cancel'
    $cancelButton.Location = New-Object System.Drawing.Point(622, 535)
    $cancelButton.Size = New-Object System.Drawing.Size(110, 34)
    $cancelButton.Anchor = 'Bottom, Right'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $dialog.Controls.Add($cancelButton)
    $dialog.AcceptButton = $applyButton
    $dialog.CancelButton = $cancelButton

    $result = $dialog.ShowDialog($form)
    $selection = if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        @($dialog.Tag)
    }
    else {
        @()
    }
    $dialog.Dispose()
    return $selection
}

function Apply-SelectedPolicies {
    param([string[]]$SelectedIds)

    if ($SelectedIds.Count -eq 0) {
        return
    }

    $results = New-Object System.Collections.Generic.List[string]
    foreach ($definition in $policyDefinitions) {
        if ($SelectedIds -notcontains $definition.Id) {
            continue
        }

        try {
            $current = Read-RegistryValue -KeyPath $definition.Key -Name $definition.Name
            if ($definition.CheckMachine) {
                $machine = Read-RegistryValue -KeyPath $definition.Key -Name $definition.Name -Hive 'LocalMachine'
                if ($machine.Exists) {
                    if ($machine.Kind -eq 'DWord' -and [int]$machine.Value -eq [int]$definition.DisabledValue) {
                        $results.Add(((T 'DeviceAlready') -f (Get-LocalizedPolicyText -Definition $definition -Property Title)))
                    }
                    else {
                        $results.Add(((T 'DeviceConflict') -f (Get-LocalizedPolicyText -Definition $definition -Property Title), $machine.Value))
                    }
                    continue
                }
            }

            if ($current.Exists -and $current.Kind -eq 'DWord' -and [int]$current.Value -eq [int]$definition.DisabledValue) {
                $results.Add(((T 'ResultAlready') -f (Get-LocalizedPolicyText -Definition $definition -Property Title)))
                continue
            }

            if ($current.Exists) {
                $results.Add(((T 'ResultExternal') -f (Get-LocalizedPolicyText -Definition $definition -Property Title)))
                try {
                    Write-ChangeLog "ПРОПУСК $($definition.Id): уже существовала политика со значением '$($current.Value)' типа $($current.Kind)."
                }
                catch {
                    $results.Add(((T 'LogWriteError') -f $_.Exception.Message))
                }
                continue
            }

            if ($config.PolicyBackups.ContainsKey($definition.Id)) {
                $results.Add(((T 'ResultPending') -f (Get-LocalizedPolicyText -Definition $definition -Property Title)))
                continue
            }

            $backup = @{
                Exists = $current.Exists
                Value = $current.Value
                Kind = $current.Kind
                AppliedValue = [int]$definition.DisabledValue
                Key = $definition.Key
                Name = $definition.Name
            }
            $config.PolicyBackups[$definition.Id] = $backup
            Save-Config
            Set-RegistryValue -KeyPath $definition.Key -Name $definition.Name -Value $definition.DisabledValue -Kind ([Microsoft.Win32.RegistryValueKind]::DWord)
            $verified = Read-RegistryValue -KeyPath $definition.Key -Name $definition.Name
            if (-not $verified.Exists -or $verified.Kind -ne 'DWord' -or [int]$verified.Value -ne [int]$definition.DisabledValue) {
                throw (T 'VerifyApplyError')
            }
            $results.Add(((T 'ResultApplied') -f (Get-LocalizedPolicyText -Definition $definition -Property Title)))
            try {
                Write-ChangeLog "ИЗМЕНЕНО $($definition.Id): $($definition.Key)\$($definition.Name) = $($definition.DisabledValue) (REG_DWORD). Предыдущее значение сохранено."
            }
            catch {
                $results.Add(((T 'LogWriteError') -f $_.Exception.Message))
            }
        }
        catch {
            $message = (T 'ApplyFailure') -f (Get-LocalizedPolicyText -Definition $definition -Property Title), $_.Exception.Message
            $results.Add($message)
            try {
                Write-ChangeLog "ОШИБКА $($definition.Id): $($_.Exception.Message)"
            }
            catch {
                $results.Add(((T 'LogWriteError') -f $_.Exception.Message))
            }
        }
    }

    Update-AppLanguageUi
    Show-TextDialog -Title (T 'ResultApplyTitle') -Text ($results -join [Environment]::NewLine)
}

function Restore-SelectedPolicies {
    if ((Get-BackupCount) -eq 0) {
        [System.Windows.Forms.MessageBox]::Show(
            (T 'RestoreNone'),
            (T 'RestoreTitle'),
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        ) | Out-Null
        return
    }

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($definition in $policyDefinitions) {
        if ($config.PolicyBackups.ContainsKey($definition.Id)) {
            $backup = $config.PolicyBackups[$definition.Id]
            if ($backup.Exists) {
                $lines.Add(((T 'RestoreValue') -f (Get-LocalizedPolicyText -Definition $definition -Property Title), $backup.Value, $backup.Kind))
            }
            else {
                $lines.Add(((T 'RestoreDelete') -f (Get-LocalizedPolicyText -Definition $definition -Property Title)))
            }
        }
    }

    $confirmation = @(
        (T 'RestoreConfirmIntro')
        ''
        ($lines -join [Environment]::NewLine)
        ''
        (T 'RestoreAdmin')
        ''
        (T 'RestoreQuestion')
    ) -join [Environment]::NewLine
    $choice = [System.Windows.Forms.MessageBox]::Show(
        $confirmation,
        (T 'RestoreTitle'),
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )
    if ($choice -ne [System.Windows.Forms.DialogResult]::Yes) {
        return
    }

    $results = New-Object System.Collections.Generic.List[string]
    foreach ($definition in $policyDefinitions) {
        if (-not $config.PolicyBackups.ContainsKey($definition.Id)) {
            continue
        }

        $backup = $config.PolicyBackups[$definition.Id]
        try {
            $current = Read-RegistryValue -KeyPath $definition.Key -Name $definition.Name
            if (Test-RegistryValueMatchesBackup -Snapshot $current -Backup $backup) {
                $results.Add(((T 'RestoreAlready') -f (Get-LocalizedPolicyText -Definition $definition -Property Title)))
            }
            elseif ($current.Exists -and $current.Kind -eq 'DWord' -and [int]$current.Value -eq [int]$backup.AppliedValue) {
                if ($backup.Exists) {
                    $kind = [Microsoft.Win32.RegistryValueKind]::$($backup.Kind)
                    Set-RegistryValue -KeyPath $definition.Key -Name $definition.Name -Value $backup.Value -Kind $kind
                }
                else {
                    Remove-RegistryValue -KeyPath $definition.Key -Name $definition.Name
                }
                $verified = Read-RegistryValue -KeyPath $definition.Key -Name $definition.Name
                if (-not (Test-RegistryValueMatchesBackup -Snapshot $verified -Backup $backup)) {
                    throw (T 'VerifyRestoreError')
                }
                $results.Add(((T 'RestoreDone') -f (Get-LocalizedPolicyText -Definition $definition -Property Title)))
                $config.PolicyBackups.Remove($definition.Id)
                Save-Config
                try {
                    Write-ChangeLog "ВОССТАНОВЛЕНО $($definition.Id): отменено изменение $($definition.Key)\$($definition.Name)."
                }
                catch {
                    $results.Add(((T 'LogWriteError') -f $_.Exception.Message))
                }
            }
            else {
                $results.Add(((T 'RestoreExternal') -f (Get-LocalizedPolicyText -Definition $definition -Property Title)))
                try {
                    Write-ChangeLog "ПРОПУСК ВОССТАНОВЛЕНИЯ $($definition.Id): текущее значение отличается от значения, установленного MaruPilot."
                }
                catch {
                    $results.Add(((T 'LogWriteError') -f $_.Exception.Message))
                }
                continue
            }

            if ($config.PolicyBackups.ContainsKey($definition.Id)) {
                $config.PolicyBackups.Remove($definition.Id)
                Save-Config
            }
        }
        catch {
            $results.Add(((T 'RestoreFailure') -f (Get-LocalizedPolicyText -Definition $definition -Property Title), $_.Exception.Message))
            try {
                Write-ChangeLog "ОШИБКА ВОССТАНОВЛЕНИЯ $($definition.Id): $($_.Exception.Message)"
            }
            catch {
                $results.Add(((T 'LogWriteError') -f $_.Exception.Message))
            }
        }
    }

    Update-Status
    Show-TextDialog -Title (T 'ResultRestoreTitle') -Text ($results -join [Environment]::NewLine)
}

function Open-ChangeLog {
    if (-not (Test-Path -LiteralPath $logPath)) {
        [System.Windows.Forms.MessageBox]::Show(
            (T 'LogEmpty'),
            (T 'LogTitle'),
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        ) | Out-Null
        return
    }

    try {
        Start-Process -FilePath 'notepad.exe' -ArgumentList ('"{0}"' -f $logPath)
    }
    catch {
        Show-ErrorDialog -Message ((T 'LogOpenError') -f $_.Exception.Message)
    }
}

function Assert-InteractiveUser {
    $sessionId = [Diagnostics.Process]::GetCurrentProcess().SessionId
    $explorer = Get-CimInstance -ClassName Win32_Process -Filter "Name='explorer.exe' AND SessionId=$sessionId" -ErrorAction Stop |
        Select-Object -First 1
    if ($null -eq $explorer) {
        throw 'Не удалось определить учётную запись рабочего стола Windows.'
    }

    $owner = Invoke-CimMethod -InputObject $explorer -MethodName GetOwnerSid -ErrorAction Stop
    if ($owner.ReturnValue -ne 0 -or [string]::IsNullOrWhiteSpace($owner.Sid)) {
        throw 'Windows не предоставил SID учётной записи рабочего стола.'
    }

    $currentSid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    if ($owner.Sid -ne $currentSid) {
        throw 'Программа запущена под другой учётной записью администратора. Закройте её и запустите от имени администратора своей учётной записи Windows, иначе будут изменены настройки другого пользователя.'
    }
}

function Invoke-BlockWorkflow {
    try {
        $rows = Get-AuditRows
        $selection = Show-BlockConfirmation -Rows $rows
        Apply-SelectedPolicies -SelectedIds $selection
    }
    catch {
        Show-ErrorDialog -Message "Не удалось подготовить изменение: $($_.Exception.Message)"
        Update-Status
    }
}

if (-not $AuditOnly) {
    try {
        Assert-InteractiveUser
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            $_.Exception.Message,
            'MaruPilot — проверка учётной записи',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
        exit 1
    }
}

if (Test-Path -LiteralPath $configPath) {
    try {
        $savedConfig = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json
        if ($null -ne $savedConfig.PolicyBackups) {
            foreach ($property in $savedConfig.PolicyBackups.PSObject.Properties) {
                $config.PolicyBackups[$property.Name] = $property.Value
            }
        }
        if ($savedConfig.Language -in @('EN', 'HU', 'UK', 'RU')) {
            $config.Language = $savedConfig.Language
            $script:currentLanguage = $savedConfig.Language
        }

        if (-not $AuditOnly -and $null -ne $savedConfig.PolicyBackup -and -not $config.PolicyBackups.ContainsKey('WindowsClassic')) {
            $config.PolicyBackups['WindowsClassic'] = @{
                Exists = [bool]$savedConfig.PolicyBackup.Exists
                Value = $savedConfig.PolicyBackup.Value
                Kind = [string]$savedConfig.PolicyBackup.Kind
                AppliedValue = 1
                Key = 'Software\Policies\Microsoft\Windows\WindowsCopilot'
                Name = 'TurnOffWindowsCopilot'
            }
            Save-Config
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            ((T 'SettingsReadError') -f $_.Exception.Message),
            (T 'ErrorTitle'),
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
        exit 1
    }
}

if ($AuditOnly) {
    $auditRows = Get-AuditRows
    Write-Output (Format-AuditReport -Rows $auditRows)
    exit 0
}

$form = New-Object System.Windows.Forms.Form
$form.Text = T 'WindowTitle'
$form.StartPosition = 'CenterScreen'
$form.Size = New-Object System.Drawing.Size(510, 390)
$form.MinimumSize = New-Object System.Drawing.Size(510, 390)
$form.Font = New-Object System.Drawing.Font('Segoe UI', 10)

$languageButtons = @{}
$languageCodes = @('EN', 'HU', 'UK', 'RU')
for ($index = 0; $index -lt $languageCodes.Count; $index++) {
    $code = $languageCodes[$index]
    $languageButton = New-Object System.Windows.Forms.Button
    $languageButton.Text = $code
    $languageButton.Location = New-Object System.Drawing.Point((296 + ($index * 47)), 14)
    $languageButton.Size = New-Object System.Drawing.Size(42, 27)
    $languageButton.Font = New-Object System.Drawing.Font('Segoe UI', 8, [System.Drawing.FontStyle]::Bold)
    $languageButton.Tag = $code
    $form.Controls.Add($languageButton)
    $languageButtons[$code] = $languageButton
}

$appIconImage = $null
if (-not [string]::IsNullOrWhiteSpace($env:MARUPILOT_ICON_PATH) -and (Test-Path -LiteralPath $env:MARUPILOT_ICON_PATH)) {
    $appIconImage = [System.Drawing.Image]::FromFile($env:MARUPILOT_ICON_PATH)
    $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($env:MARUPILOT_EXECUTABLE)

    $iconPicture = New-Object System.Windows.Forms.PictureBox
    $iconPicture.Location = New-Object System.Drawing.Point(27, 56)
    $iconPicture.Size = New-Object System.Drawing.Size(42, 42)
    $iconPicture.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $iconPicture.Image = $appIconImage
    $form.Controls.Add($iconPicture)
}

$title = New-Object System.Windows.Forms.Label
$title.Text = 'MaruPilot'
$title.Font = New-Object System.Drawing.Font('Segoe UI', 20, [System.Drawing.FontStyle]::Bold)
$title.Location = New-Object System.Drawing.Point(78, 58)
$title.AutoSize = $true
$form.Controls.Add($title)

$description = New-Object System.Windows.Forms.Label
$description.Text = T 'Description'
$description.Location = New-Object System.Drawing.Point(27, 102)
$description.Size = New-Object System.Drawing.Size(445, 24)
$form.Controls.Add($description)

$channelLabel = New-Object System.Windows.Forms.Label
$channelLabel.Text = T 'ChannelLabel'
$channelLabel.Location = New-Object System.Drawing.Point(27, 144)
$channelLabel.AutoSize = $true
$form.Controls.Add($channelLabel)

$channelLink = New-Object System.Windows.Forms.LinkLabel
$channelLink.Text = T 'ChannelLink'
$channelLink.Location = New-Object System.Drawing.Point(27, 170)
$channelLink.AutoSize = $true
$channelLink.LinkColor = [System.Drawing.Color]::FromArgb(0, 102, 204)
$channelLink.LinkArea = New-Object System.Windows.Forms.LinkArea(0, $channelLink.Text.Length)
$form.Controls.Add($channelLink)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(27, 212)
$statusLabel.Size = New-Object System.Drawing.Size(440, 28)
$form.Controls.Add($statusLabel)

$toggleButton = New-Object System.Windows.Forms.Button
$toggleButton.Location = New-Object System.Drawing.Point(27, 247)
$toggleButton.Size = New-Object System.Drawing.Size(440, 42)
$toggleButton.Font = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($toggleButton)

$notice = New-Object System.Windows.Forms.Label
$notice.Text = T 'Notice'
$notice.Location = New-Object System.Drawing.Point(27, 303)
$notice.Size = New-Object System.Drawing.Size(440, 58)
$notice.ForeColor = [System.Drawing.Color]::DimGray
$notice.Font = New-Object System.Drawing.Font('Segoe UI', 8)
$form.Controls.Add($notice)

$contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
$auditMenuItem = $contextMenu.Items.Add((T 'MenuAudit'))
$restoreMenuItem = $contextMenu.Items.Add((T 'MenuRestore'))
$logMenuItem = $contextMenu.Items.Add((T 'MenuLog'))
$auditMenuItem.Add_Click({ Show-SystemAudit })
$restoreMenuItem.Add_Click({ Restore-SelectedPolicies })
$logMenuItem.Add_Click({ Open-ChangeLog })
$form.ContextMenuStrip = $contextMenu
foreach ($control in @($title, $description, $channelLabel, $channelLink, $statusLabel, $toggleButton, $notice)) {
    $control.ContextMenuStrip = $contextMenu
}
$toolTip = New-Object System.Windows.Forms.ToolTip
$toolTip.SetToolTip($statusLabel, (T 'TipStatus'))
$toolTip.SetToolTip($toggleButton, (T 'TipButton'))

function Update-AppLanguageUi {
    $form.Text = T 'WindowTitle'
    $description.Text = T 'Description'
    $channelLabel.Text = T 'ChannelLabel'
    $channelLink.Text = T 'ChannelLink'
    $channelLink.LinkArea = New-Object System.Windows.Forms.LinkArea(0, $channelLink.Text.Length)
    $notice.Text = T 'Notice'
    $auditMenuItem.Text = T 'MenuAudit'
    $restoreMenuItem.Text = T 'MenuRestore'
    $logMenuItem.Text = T 'MenuLog'
    $toolTip.SetToolTip($statusLabel, (T 'TipStatus'))
    $toolTip.SetToolTip($toggleButton, (T 'TipButton'))
    foreach ($code in $languageButtons.Keys) {
        if ($code -eq $script:currentLanguage) {
            $languageButtons[$code].BackColor = [System.Drawing.Color]::FromArgb(220, 235, 250)
        }
        else {
            $languageButtons[$code].BackColor = [System.Drawing.SystemColors]::Control
        }
    }
    Update-Status
}

function Set-AppLanguage {
    param(
        [ValidateSet('HU', 'UK', 'RU', 'EN')]
        [string]$Language,
        [switch]$Persist
    )

    $previousLanguage = $script:currentLanguage
    $script:currentLanguage = $Language
    $config.Language = $Language
    if ($Persist) {
        try {
            Save-Config
        }
        catch {
            $script:currentLanguage = $previousLanguage
            $config.Language = $previousLanguage
            Update-AppLanguageUi
            throw [System.InvalidOperationException]::new(((T 'LanguageSaveError') -f $_.Exception.Message), $_.Exception)
        }
    }
    Update-AppLanguageUi
}

foreach ($languageButton in $languageButtons.Values) {
    $languageButton.Add_Click({
        try {
            Set-AppLanguage -Language ([string]$this.Tag) -Persist
        }
        catch {
            Show-ErrorDialog -Message $_.Exception.Message
        }
    })
}

$channelLink.Add_LinkClicked({
    try {
        Start-Process -FilePath 'https://www.youtube.com/@%D0%9A%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D0%B0%D0%BD%D0%B5%D0%BE%D0%BD-%D1%836%D1%83'
    }
    catch {
        Show-ErrorDialog -Message ((T 'ChannelError') -f $_.Exception.Message)
    }
})

$toggleButton.Add_Click({
    if ((Get-BackupCount) -gt 0) {
        Restore-SelectedPolicies
    }
    else {
        Invoke-BlockWorkflow
    }
})

Update-Status
[void]$form.ShowDialog()
$form.Dispose()
$toolTip.Dispose()
$contextMenu.Dispose()
if ($null -ne $appIconImage) {
    $appIconImage.Dispose()
}
