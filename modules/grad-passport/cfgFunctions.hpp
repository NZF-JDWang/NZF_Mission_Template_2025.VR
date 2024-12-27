#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY modules
#endif

class grad_passport {
    class passport {
        file = MODULES_DIRECTORY\grad-passport\functions;

        class generateSerial {};
        class getPassportData {};
        class initModule {postInit = 1;};
        class onShowDialogClose {};
        class onViewDialogClose {};
        class receiveShowPassport {};
        class showPassport {};
        class updateShowPassportDialog {};
        class viewPassport {};
    };
};
