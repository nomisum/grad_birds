class cfgFunctions {
    class GRAD_crows {

        class crows_client {
                file = crows\functions\client;

                class crowCreate {};
                class crowGetWp {};
                class crowLoop {};
                class crowLoopSingle {};
                class crowMoveNear {};
                class crowMoveTo {};
                class crowSingleCreate {};
                class setBirdTarget {};
                class setCirclePoint {};
                class startleBirds {};
        };

        class crows_server {
                file = crows\functions\server;

                class createCrows;
                class debugMarker;
                class flockingAlgorithm;
                class getObjectDimensions;
                class getTerrainObjects;
                
                class initCrows { postInit = 1; };

                class startleFlock;
        };

    };
};