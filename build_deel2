let ServicesService = class ServicesService {
    constructor(http) {
        this.http = http;
        this.isLoggedin = new rxjs__WEBPACK_IMPORTED_MODULE_3__["BehaviorSubject"](false);
        this.userSubject = new rxjs__WEBPACK_IMPORTED_MODULE_3__["BehaviorSubject"](new _models_gebruiker_model__WEBPACK_IMPORTED_MODULE_4__["Gebruiker"](null$
        this.user = this.userSubject.asObservable();
        this.isAdminSubject = new rxjs__WEBPACK_IMPORTED_MODULE_3__["BehaviorSubject"](false);
        this.isAdmin = this.isAdminSubject.asObservable();
    }
    //Vinificatieprocessen
    getAllProcessen() {
        return this.http.get(baselink + "Vinificatie/read.php");
    }
    getAllInactieveProcessen() {
        return this.http.get(baselink + "Vinificatie/nietActief.php");
    }
    addProces(process) {
        return Object(rxjs__WEBPACK_IMPORTED_MODULE_3__["from"])(// wrap the fetch in a from if you need an rxjs Observable
        fetch(baselink + "Vinificatie/create.php", {
