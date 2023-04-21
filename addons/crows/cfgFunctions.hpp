class cfgFunctions {
    class GRAD_crows {

        class crows_client {
                file = crows\functions\client;
                
                class crowLoop;
                class crowMoveTo;
                class flockingAlgorithm;

                class startleFlock;
        };

        class crows_server {
                file = crows\functions\server;

                class cacheTerrainObjects;
                class checkTimeout;

                class createCrows;
                class createDetector;
                class debugMarker;
                class getObjectDimensions;
                
                class initCrows { postInit = 1; };

                class triggerStartle;
        };

    };
};