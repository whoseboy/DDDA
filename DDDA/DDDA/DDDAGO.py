#!/usr/bin/env python
# coding: utf-8

# In[1]:


class DDDA:
    def __init__(self, *args, **kwargs):
        if len(args) == 0:
            print('No data')
        else:
            try: 
                self.Dataf = args[0]
            except:
                print('0')
            else:
                self.Dataf = args[0]

            try: 
                self.DataX = args[1]
            except:
                print('1')
            else:
                self.DataX = args[1]

            try: 
                self.DataY = args[2]
            except:
                print('2')
            else:
                self.DataY = args[2]

            try: 
                self.DataZ = args[3]
            except:
                print('3')
            else:
                self.DataZ = args[3]    
# Dict
            try: 
                self.InterLength = kwargs['InterLength']
            except:
                print('default interLength')
                self.InterLength = round(len(args[0]) ** (1 / (len(args) - 1)))
            else:
                self.InterLength = round(\
                                         kwargs['InterLength'] * \
                                             len(args[0]) ** (1 / (len(args) - 1)))

            try: 
                self.r0 = kwargs['r0']
            except:
                print('default r0 is 3')
                self.r0 = 3
            else:
                self.r0 = kwargs['r0']

            try: 
                self.rn = kwargs['rn']
            except:
                print('default rn is 10')
                self.rn = 10
            else:
                self.rn = kwargs['rn']

            try: 
                self.Claster = kwargs['Claster']
            except:
                print('default Cluster is 2')
                self.Claster = 2
            else:
                self.Claster = kwargs['Claster']       

            try: 
                self.InterShift = kwargs['InterShift']
            except:
                print('default InterShift')
                self.InterShift = (max(args[1]) - min(args[1])) * 0.1
            else:
                self.InterShift = kwargs['InterShift'] * \
                (max(args[1]) - min(args[1]))        

    def DDDARun(self):
        import numpy as np
        import copy
        import matplotlib.pyplot as plt 
        import scipy.io as scio
        from mpl_toolkits.mplot3d import axes3d
        import pandas as pd
        import scipy.stats as stats
        import math
        from numba import jit # Accelerator
        from scipy.spatial import Voronoi, ConvexHull
        from sklearn.neighbors import KDTree, KernelDensity
        from sklearn.model_selection import GridSearchCV
        import platform
        import seaborn as sns
        DataX = self.DataX
        DataY = self.DataY
        DataZ = self.DataZ
        DataF = self.Dataf
        
        DataX = DataX.reshape((np.size(DataX), 1))  
        DataY = DataY.reshape((np.size(DataY), 1))
        DataZ = DataZ.reshape((np.size(DataZ), 1))        
        DataF = DataF.reshape((np.size(DataF), 1))
        
        DataLength = int(len(DataX) ** (1/3))
        NoPin1D = DataLength


        
        NoPs = int(NoPin1D ** 2)
        
        n = self.InterLength
        InterShift = self.InterShift
        
        Inter_Left_x = min(DataX) + InterShift
        Inter_Right_x = max(DataX) - InterShift
        Inter_Left_y = min(DataY) + InterShift
        Inter_Right_y = max(DataY) - InterShift
        Inter_Left_z = min(DataZ) + InterShift
        Inter_Right_z = max(DataZ) - InterShift
        
        RoughMinAxis = min([Inter_Right_x - Inter_Left_x, \
                    Inter_Right_y - Inter_Left_y, \
                    Inter_Right_z - Inter_Left_z])

        RoughMindis = RoughMinAxis / NoPin1D
        
        r1 = self.r0
        rn = self.rn
        Trunc_r_0 = RoughMindis * r1
        Trunc_r_1 = Trunc_r_0 * 1.5
        Trunc_rn = rn

        h_0 = Trunc_r_0 / 2.5
        h_1 = h_0 * 2
        hn = rn

        ClusterRegion = self.Claster
        
    # Temporary parameter for boundary reflection
        X_mid = (max(DataX) - min(DataX))/2 + min(DataX)
        Y_mid = (max(DataY) - min(DataY))/2 + min(DataY)
        Z_mid = (max(DataZ) - min(DataZ))/2 + min(DataZ)

        #Xmin Y-Z plane
        DataX_Xmin_Ori = copy.deepcopy(DataX)
        DataY_Xmin_Ori = copy.deepcopy(DataY)
        DataZ_Xmin_Ori = copy.deepcopy(DataZ)
        DataF_Xmin_Ori = copy.deepcopy(DataF)

        XMinx_Frame = np.zeros((NoPs,1))
        XMiny_Frame = np.zeros((NoPs,1))
        XMinz_Frame = np.zeros((NoPs,1))
        XMinx_M1 = np.zeros((NoPs,1))
        XMiny_M1 = np.zeros((NoPs,1))
        XMinz_M1 = np.zeros((NoPs,1))

        #Frame - The reference line
        for PtN in range(NoPs):
            PT_temp = DataX_Xmin_Ori.argmin()
            XMinx_Frame[PtN] = DataX_Xmin_Ori[PT_temp]
            XMiny_Frame[PtN] = DataY_Xmin_Ori[PT_temp]
            XMinz_Frame[PtN] = DataZ_Xmin_Ori[PT_temp]

            DataX_Xmin_Ori[PT_temp] = X_mid
            DataY_Xmin_Ori[PT_temp] = Y_mid
            DataZ_Xmin_Ori[PT_temp] = Z_mid

        # M1 & M1m Line 
        for PtN in range(NoPs):
            PT_temp = DataX_Xmin_Ori.argmin()
            XMinx_M1[PtN] = DataX_Xmin_Ori[PT_temp]
            XMiny_M1[PtN] = DataY_Xmin_Ori[PT_temp]
            XMinz_M1[PtN] = DataZ_Xmin_Ori[PT_temp]

        # Cutting Reflection
        XMinx_FrameR = -1 * XMinx_Frame
        Xmin_Offset = np.abs(np.mean(XMinx_Frame - XMinx_M1))
        Xmin_GAP = np.abs(np.mean(XMinx_Frame - XMinx_FrameR))
        XMinx_CR = XMinx_FrameR + Xmin_GAP - Xmin_Offset 

        DataX_xmin_DONE = np.vstack((DataX, XMinx_CR))
        DataY_xmin_DONE = np.vstack((DataY, XMiny_Frame))
        DataZ_xmin_DONE = np.vstack((DataZ, XMinz_Frame))

        # Left boundary reflection 
        # Yellow reflected points, Red Reference points

        #Zmin X-Y plane
        NoPs = 1640
        DataX_Zmin_Ori = copy.deepcopy(DataX_xmin_DONE)
        DataY_Zmin_Ori = copy.deepcopy(DataY_xmin_DONE)
        DataZ_Zmin_Ori = copy.deepcopy(DataZ_xmin_DONE)

        ZMinx_Frame = np.zeros((NoPs,1))
        ZMiny_Frame = np.zeros((NoPs,1))
        ZMinz_Frame = np.zeros((NoPs,1))
        ZMinx_M1 = np.zeros((NoPs,1))
        ZMiny_M1 = np.zeros((NoPs,1))
        ZMinz_M1 = np.zeros((NoPs,1))

        #Frame - The reference line
        for PtN in range(NoPs):
            PT_temp = DataZ_Zmin_Ori.argmin()
            ZMinx_Frame[PtN] = DataX_Zmin_Ori[PT_temp]
            ZMiny_Frame[PtN] = DataY_Zmin_Ori[PT_temp]
            ZMinz_Frame[PtN] = DataZ_Zmin_Ori[PT_temp]

            DataX_Zmin_Ori[PT_temp] = X_mid
            DataY_Zmin_Ori[PT_temp] = Y_mid
            DataZ_Zmin_Ori[PT_temp] = Z_mid


        # M1 & M1m Line 
        for PtN in range(NoPs):
            PT_temp = DataZ_Zmin_Ori.argmin()
            ZMinx_M1[PtN] = DataX_Zmin_Ori[PT_temp]
            ZMiny_M1[PtN] = DataY_Zmin_Ori[PT_temp]
            ZMinz_M1[PtN] = DataZ_Zmin_Ori[PT_temp]

        # Cutting Reflection
        ZMinz_FrameR = -1 * ZMinz_Frame
        Zmin_Offset = np.abs(np.mean(ZMinz_Frame - ZMinz_M1))
        Zmin_GAP = np.abs(np.mean(ZMinz_Frame - ZMinz_FrameR))
        ZMinz_CR = ZMinz_FrameR - Zmin_GAP - Zmin_Offset

        DataX_Zmin_DONE = np.vstack((DataX_xmin_DONE, ZMinx_Frame))
        DataY_Zmin_DONE = np.vstack((DataY_xmin_DONE, ZMiny_Frame))
        DataZ_Zmin_DONE = np.vstack((DataZ_xmin_DONE, ZMinz_CR))

        # Left boundary reflection 
        # Yellow reflected points, Red Reference points

        #Ymin X-Z plane
        NoPs = 1681
        DataX_Ymin_Ori = copy.deepcopy(DataX_Zmin_DONE)
        DataY_Ymin_Ori = copy.deepcopy(DataY_Zmin_DONE)
        DataZ_Ymin_Ori = copy.deepcopy(DataZ_Zmin_DONE)

        YMinx_Frame = np.zeros((NoPs,1))
        YMiny_Frame = np.zeros((NoPs,1))
        YMinz_Frame = np.zeros((NoPs,1))
        YMinx_M1 = np.zeros((NoPs,1))
        YMiny_M1 = np.zeros((NoPs,1))
        YMinz_M1 = np.zeros((NoPs,1))

        #Frame - The reference line
        for PtN in range(NoPs):
            PT_temp = DataY_Ymin_Ori.argmin()
            YMinx_Frame[PtN] = DataX_Ymin_Ori[PT_temp]
            YMiny_Frame[PtN] = DataY_Ymin_Ori[PT_temp]
            YMinz_Frame[PtN] = DataZ_Ymin_Ori[PT_temp]

            DataX_Ymin_Ori[PT_temp] = X_mid
            DataY_Ymin_Ori[PT_temp] = Y_mid
            DataZ_Ymin_Ori[PT_temp] = Z_mid

        # M1 & M1m Line 
        for PtN in range(NoPs):
            PT_temp = DataY_Ymin_Ori.argmin()
            YMinx_M1[PtN] = DataX_Ymin_Ori[PT_temp]
            YMiny_M1[PtN] = DataY_Ymin_Ori[PT_temp]
            YMinz_M1[PtN] = DataZ_Ymin_Ori[PT_temp]

        # Cutting Reflection
        YMiny_FrameR = -1 * YMiny_Frame
        Ymin_Offset = np.abs(np.mean(YMiny_Frame - YMiny_M1))
        Ymin_GAP = np.abs(np.mean(YMiny_Frame - YMiny_FrameR))
        YMiny_CR = YMiny_FrameR + Ymin_GAP - Ymin_Offset

        DataX_Ymin_DONE = np.vstack((DataX_Zmin_DONE, YMinx_Frame))
        DataY_Ymin_DONE = np.vstack((DataY_Zmin_DONE, YMiny_CR))
        DataZ_Ymin_DONE = np.vstack((DataZ_Zmin_DONE, YMinz_Frame))

        # Left boundary reflection 
        # Yellow reflected points, Red Reference points

        #Xmax Y-Z plane
        NoPs = 1681
        DataX_Xmax_Ori = copy.deepcopy(DataX_Ymin_DONE)
        DataY_Xmax_Ori = copy.deepcopy(DataY_Ymin_DONE)
        DataZ_Xmax_Ori = copy.deepcopy(DataZ_Ymin_DONE)

        XMaxx_Frame = np.zeros((NoPs,1))
        XMaxy_Frame = np.zeros((NoPs,1))
        XMaxz_Frame = np.zeros((NoPs,1))
        XMaxx_M1 = np.zeros((NoPs,1))
        XMaxy_M1 = np.zeros((NoPs,1))
        XMaxz_M1 = np.zeros((NoPs,1))

        #Frame - The reference line
        for PtN in range(NoPs):
            PT_temp = DataX_Xmax_Ori.argmax()
            XMaxx_Frame[PtN] = DataX_Xmax_Ori[PT_temp]
            XMaxy_Frame[PtN] = DataY_Xmax_Ori[PT_temp]
            XMaxz_Frame[PtN] = DataZ_Xmax_Ori[PT_temp]

            DataX_Xmax_Ori[PT_temp] = X_mid
            DataY_Xmax_Ori[PT_temp] = Y_mid
            DataZ_Xmax_Ori[PT_temp] = Z_mid


        # M1 & M1m Line 
        for PtN in range(NoPs):
            PT_temp = DataX_Xmax_Ori.argmax()
            XMaxx_M1[PtN] = DataX_Xmax_Ori[PT_temp]
            XMaxy_M1[PtN] = DataY_Xmax_Ori[PT_temp]
            XMaxz_M1[PtN] = DataZ_Xmax_Ori[PT_temp]

        # Cutting Reflection
        XMaxx_FrameR = -1 * XMaxx_Frame
        Xmax_Offset = np.abs(np.mean(XMaxx_Frame - XMaxx_M1))
        Xmax_GAP = np.abs(np.mean(XMaxx_Frame - XMaxx_FrameR))
        XMaxx_CR = XMaxx_FrameR + Xmax_GAP + Xmax_Offset

        DataX_Xmax_DONE = np.vstack((DataX_Ymin_DONE, XMaxx_CR))
        DataY_Xmax_DONE = np.vstack((DataY_Ymin_DONE, XMaxy_Frame))
        DataZ_Xmax_DONE = np.vstack((DataZ_Ymin_DONE, XMaxz_Frame))

        # Left boundary reflection 
        # Yellow reflected points, Red Reference points

        #Ymax X-Z plane
        NoPs = 1722
        DataX_Ymax_Ori = copy.deepcopy(DataX_Xmax_DONE)
        DataY_Ymax_Ori = copy.deepcopy(DataY_Xmax_DONE)
        DataZ_Ymax_Ori = copy.deepcopy(DataZ_Xmax_DONE)

        YMaxx_Frame = np.zeros((NoPs,1))
        YMaxy_Frame = np.zeros((NoPs,1))
        YMaxz_Frame = np.zeros((NoPs,1))
        YMaxx_M1 = np.zeros((NoPs,1))
        YMaxy_M1 = np.zeros((NoPs,1))
        YMaxz_M1 = np.zeros((NoPs,1))

        #Frame - The reference line
        for PtN in range(NoPs):
            PT_temp = DataY_Ymax_Ori.argmax()
            YMaxx_Frame[PtN] = DataX_Ymax_Ori[PT_temp]
            YMaxy_Frame[PtN] = DataY_Ymax_Ori[PT_temp]
            YMaxz_Frame[PtN] = DataZ_Ymax_Ori[PT_temp]

            DataX_Ymax_Ori[PT_temp] = X_mid
            DataY_Ymax_Ori[PT_temp] = Y_mid
            DataZ_Ymax_Ori[PT_temp] = Z_mid


        # M1 & M1m Line 
        for PtN in range(NoPs):
            PT_temp = DataY_Ymax_Ori.argmax()
            YMaxx_M1[PtN] = DataX_Ymax_Ori[PT_temp]
            YMaxy_M1[PtN] = DataY_Ymax_Ori[PT_temp]
            YMaxz_M1[PtN] = DataZ_Ymax_Ori[PT_temp]

        # Cutting Reflection
        YMaxy_FrameR = -1 * YMaxy_Frame
        Ymax_Offset = np.abs(np.mean(YMaxy_Frame - YMaxy_M1))
        Ymax_GAP = np.abs(np.mean(YMaxy_Frame - YMaxy_FrameR))
        YMaxy_CR = YMaxy_FrameR + Ymax_GAP + Ymax_Offset

        DataX_Ymax_DONE = np.vstack((DataX_Xmax_DONE, YMaxx_Frame))
        DataY_Ymax_DONE = np.vstack((DataY_Xmax_DONE, YMaxy_CR))
        DataZ_Ymax_DONE = np.vstack((DataZ_Xmax_DONE, YMaxz_Frame))

        # Left boundary reflection 
        # Yellow reflected points, Red Reference points

        #Zmax X-Y plane
        NoPs = 1764
        DataX_Zmax_Ori = copy.deepcopy(DataX_Ymax_DONE)
        DataY_Zmax_Ori = copy.deepcopy(DataY_Ymax_DONE)
        DataZ_Zmax_Ori = copy.deepcopy(DataZ_Ymax_DONE)

        ZMaxx_Frame = np.zeros((NoPs,1))
        ZMaxy_Frame = np.zeros((NoPs,1))
        ZMaxz_Frame = np.zeros((NoPs,1))
        ZMaxx_M1 = np.zeros((NoPs,1))
        ZMaxy_M1 = np.zeros((NoPs,1))
        ZMaxz_M1 = np.zeros((NoPs,1))

        #Frame - The reference line
        for PtN in range(NoPs):
            PT_temp = DataZ_Zmax_Ori.argmax()
            ZMaxx_Frame[PtN] = DataX_Zmax_Ori[PT_temp]
            ZMaxy_Frame[PtN] = DataY_Zmax_Ori[PT_temp]
            ZMaxz_Frame[PtN] = DataZ_Zmax_Ori[PT_temp]

            DataX_Zmax_Ori[PT_temp] = X_mid
            DataY_Zmax_Ori[PT_temp] = Y_mid
            DataZ_Zmax_Ori[PT_temp] = Z_mid

        # M1 & M1m Line 
        for PtN in range(NoPs):
            PT_temp = DataZ_Zmax_Ori.argmax()
            ZMaxx_M1[PtN] = DataX_Zmax_Ori[PT_temp]
            ZMaxy_M1[PtN] = DataY_Zmax_Ori[PT_temp]
            ZMaxz_M1[PtN] = DataZ_Zmax_Ori[PT_temp]

        # Cutting Reflection
        ZMaxz_FrameR = -1 * ZMaxz_Frame
        Zmax_Offset = np.abs(np.mean(ZMaxz_Frame - ZMaxz_M1))
        Zmax_GAP = np.abs(np.mean(ZMaxz_Frame - ZMaxz_FrameR))
        ZMaxz_CR = ZMaxz_FrameR + Zmax_GAP + Zmax_Offset

        DataX_Zmax_DONE = np.vstack((DataX_Ymax_DONE, ZMaxx_Frame))
        DataY_Zmax_DONE = np.vstack((DataY_Ymax_DONE, ZMaxy_Frame))
        DataZ_Zmax_DONE = np.vstack((DataZ_Ymax_DONE, ZMaxz_CR))

        # Left boundary reflection 
        # Yellow reflected points, Red Reference points

        # Show points cloud and reflected boundary
        Data3D_x = copy.deepcopy(DataX_Zmax_DONE)
        Data3D_y = copy.deepcopy(DataY_Zmax_DONE)
        Data3D_z = copy.deepcopy(DataZ_Zmax_DONE)
        Data3D = np.hstack((Data3D_x, Data3D_y, Data3D_z))

        vor = Voronoi(Data3D)
        vor_vertices = copy.deepcopy(vor.vertices)
        vor_regions = copy.deepcopy(vor.regions)

        # The crude votonoi cell, the boundary was tend to infinity

        OriginNoCell = len(vor_regions)

        NoVoronoiCell = len(vor.regions)
        V_vertices_x = copy.deepcopy(vor.vertices[:, 0])
        V_vertices_y = copy.deepcopy(vor.vertices[:, 1])
        V_vertices_z = copy.deepcopy(vor.vertices[:, 2])

        V_coord_x = [ [] for _ in range(NoVoronoiCell) ]
        V_coord_y = [ [] for _ in range(NoVoronoiCell) ]
        V_coord_z = [ [] for _ in range(NoVoronoiCell) ]

        XMax = np.max(XMaxx_CR - 0.3 * Xmax_Offset)
        YMax = np.max(YMaxy_CR - 0.3 * Ymax_Offset)
        ZMax = np.max(ZMaxz_CR - 0.3 * Zmax_Offset)
        XMin = np.max(XMinx_CR - 0.3 * Xmin_Offset)
        YMin = np.max(YMiny_CR - 0.3 * Ymin_Offset)
        ZMin = np.max(ZMinz_CR - 0.3 * Zmax_Offset)

        # Delete the exceed points which behind or wothin 'The frame' in 
        # section 1.2 boundary secure
        NoPs = 42
        XGrid_ST = (XMax - XMin)/NoPs
        YGrid_ST = (YMax - YMin)/NoPs
        ZGrid_ST = (ZMax - ZMin)/NoPs


        VEmptyCount = 0
        Cell_STD_x = np.zeros(NoVoronoiCell)
        Cell_STD_y = np.zeros(NoVoronoiCell)
        Cell_STD_z = np.zeros(NoVoronoiCell)

        for i in range(NoVoronoiCell):

            DeleteHint = 0;
            VL_Temp = len(vor.regions[i])

            if VL_Temp == 0:
                continue

            V_coord_x[i] = np.zeros(VL_Temp)
            V_coord_y[i] = np.zeros(VL_Temp)
            V_coord_z[i] = np.zeros(VL_Temp)
            Ori_Check_x = np.zeros(VL_Temp)
            Ori_Check_y = np.zeros(VL_Temp)
            Ori_Check_z = np.zeros(VL_Temp)

            for j in range(VL_Temp):
                NoC = vor.regions[i][j]
                V_coord_x[i][j] = V_vertices_x[NoC]
                V_coord_y[i][j] = V_vertices_y[NoC]
                V_coord_z[i][j] = V_vertices_z[NoC]
                Ori_Check_x[j] = V_vertices_x[NoC]
                Ori_Check_y[j] = V_vertices_y[NoC]
                Ori_Check_z[j] = V_vertices_z[NoC]

                if V_coord_x[i][j] < XMin and np.std(V_coord_x[i]) > XGrid_ST * 0.6:

                    V_coord_x[i] = []
                    V_coord_y[i] = []
                    V_coord_z[i] = []
                    VEmptyCount = VEmptyCount + 1
                    DeleteHint = 1
                    break
                elif V_coord_x[i][j] > XMax and np.std(V_coord_x[i]) > XGrid_ST * 0.6:
                    V_coord_x[i] = []
                    V_coord_y[i] = []
                    V_coord_z[i] = []
                    VEmptyCount = VEmptyCount + 1
                    DeleteHint = 1
                    break
                elif V_coord_y[i][j] > YMax and np.std(V_coord_y[i]) > XGrid_ST * 0.6: 
                    V_coord_x[i] = []
                    V_coord_y[i] = []
                    V_coord_z[i] = []
                    VEmptyCount = VEmptyCount + 1
                    DeleteHint = 1
                    break
                elif V_coord_y[i][j] < YMin and np.std(V_coord_y[i]) > XGrid_ST * 0.6:
                    V_coord_x[i] = []
                    V_coord_y[i] = []
                    V_coord_z[i] = []
                    VEmptyCount = VEmptyCount + 1
                    DeleteHint = 1
                    break
                elif V_coord_z[i][j] > ZMax and np.std(V_coord_z[i]) > XGrid_ST * 0.6: 
                    V_coord_x[i] = []
                    V_coord_y[i] = []
                    V_coord_z[i] = []
                    VEmptyCount = VEmptyCount + 1
                    DeleteHint = 1
                    break
                elif V_coord_z[i][j] < ZMin and np.std(V_coord_z[i]) > XGrid_ST * 0.6:
                    V_coord_x[i] = []
                    V_coord_y[i] = []
                    V_coord_z[i] = []
                    VEmptyCount = VEmptyCount + 1
                    DeleteHint = 1
                    break

            if DeleteHint == 0:                
                V_coord_x[i] = np.append(V_coord_x[i], V_coord_x[i][0])
                V_coord_y[i] = np.append(V_coord_y[i], V_coord_y[i][0])
                V_coord_z[i] = np.append(V_coord_z[i], V_coord_z[i][0])


        NewNoPCell = len(V_coord_x)


        NewIndex = 0
        NewV_coord_x = list()
        NewV_coord_y = list()
        NewV_coord_z = list()

        for NoC in range(len(vor.regions)):
            if len(V_coord_x[NoC]) == 0:
                continue
            elif len(V_coord_x[NoC]) != 0 and NewIndex == 0:
                NewV_coord_x.append(V_coord_x[NoC])
                NewV_coord_y.append(V_coord_y[NoC])
                NewV_coord_z.append(V_coord_z[NoC])
                NewIndex = NewIndex + 1
            else:
                NewV_coord_x.append(V_coord_x[NoC])
                NewV_coord_y.append(V_coord_y[NoC])
                NewV_coord_z.append(V_coord_z[NoC])
                NewIndex = NewIndex + 1

        VolVoeSubj = np.zeros(NewIndex)
        OutBoundaryCount = 0

        for i in range(NewIndex):
            CellL = len(NewV_coord_x[i])
            xxx = np.zeros((CellL, 3))
            WrongCell = 0

            for j in range(CellL):

                xxx[j][0] = NewV_coord_x[i][j]
                xxx[j][1] = NewV_coord_y[i][j]
                xxx[j][2] = NewV_coord_z[i][j]
            try:
                vvvv = ConvexHull(xxx)
            except:
                VolVoeSubj[i] = 0
                OutBoundaryCount = OutBoundaryCount + 1
            else:
                VolVoeSubj[i] = vvvv.volume

        NewNoPCell = len(VolVoeSubj)


        for i in range(NewNoPCell):
            if VolVoeSubj[i] > 0.001:
                VolVoeSubj[i] = 0



        Inter_Data_x = np.linspace(Inter_Left_x, Inter_Right_x, num = n)
        Inter_Data_y = np.linspace(Inter_Left_y, Inter_Right_y, num = n)
        Inter_Data_z = np.linspace(Inter_Left_z, Inter_Right_z, num = n)

        x_Inter = np.zeros(pow(n, 3))
        y_Inter = np.zeros(pow(n, 3))
        z_Inter = np.zeros(pow(n, 3))

        for xIndex in range(n):
            for yIndex in range(n):
                for zIndex in range(n):

                    x_Inter[xIndex * n * n + yIndex  * n + zIndex] = \
                    Inter_Data_x[xIndex]
                    y_Inter[xIndex * n * n + yIndex  * n + zIndex] = \
                    Inter_Data_y[yIndex]
                    z_Inter[xIndex * n * n + yIndex  * n + zIndex] = \
                    Inter_Data_z[zIndex]

        x_Inter = np.reshape(x_Inter, (len(x_Inter), 1))
        y_Inter = np.reshape(y_Inter, (len(y_Inter), 1))
        z_Inter = np.reshape(z_Inter, (len(z_Inter), 1))



        DataSet_3D = np.hstack((DataX, DataY, DataZ))
        InterSet_3D = np.hstack((x_Inter, y_Inter, z_Inter))


        Trunc_r_range = np.linspace(Trunc_r_0, Trunc_r_1, Trunc_rn)

        def DomainCutoff(DataSet, Interpoints, r_range, rn):
            PoinsInd = []
            distance = []

            tree = KDTree(DataSet)  # Assign K-D tree
            for i in range(rn):

                PoinsInd_one, distance_one = tree.query_radius(Interpoints, \
                                                               r = r_range[i], \
                                            return_distance=True)
                PoinsInd.append(PoinsInd_one)
                distance.append(distance_one)
            return PoinsInd, distance

        PoinsInd, distance, = DomainCutoff(DataSet_3D, InterSet_3D, \
                                                      Trunc_r_range, Trunc_rn)


        h_range = np.linspace(h_0, h_1, hn)

        # Gaussion constant coordinate
        aGau = list(map(lambda x: 1 / (pow(math.pi, 1.5) * pow(x, 3)), h_range))
        aGau = np.array(aGau)

        # Gaussian kernel with varis support domain & truncate domain
        @jit(nopython=True)
        def DistanceAll(distance, PoinsIndNP, VolVoeSubj, aGau, h):

            N_Data = int(len(distance))
            W_Gau_0th = 0
            W_Gau_1st = 0

            for j in range(N_Data):

                q = distance[j] / h
                W_GauN = aGau * (2.7128 ** ( -1 * (q ** 2)))
                # 0th moment
                W_Gau_0th = W_Gau_0th + W_GauN * VolVoeSubj[PoinsIndNP[j]]
                # 1st moment
                W_Gau_1st = W_Gau_1st + \
                W_GauN * VolVoeSubj[PoinsIndNP[j]] * distance[j] 

            return(W_Gau_0th, W_Gau_1st, N_Data)

        Q_length = len(distance[0])
        W_Gau_0th_vari = np.zeros((Trunc_rn, hn, Q_length))
        W_Gau_1st_vari = np.zeros((Trunc_rn, hn, Q_length))
        N_Data = np.zeros((Trunc_rn, Q_length))
        for k in range(Trunc_rn):
            distanceNP = np.array(distance[k][0:])
            PoinsIndNP = np.array(PoinsInd[k])

            for j in range(hn):
                aGauNP = aGau[j]
                h = h_range[j]
                for i in range(Q_length) :
                    W_Gau_0th_vari[k, j, i], W_Gau_1st_vari[k, j, i], N_Data[k, i]= \
                    DistanceAll(distanceNP[i], PoinsIndNP[i], VolVoeSubj, \
                                            aGauNP[0], h[0])


#         # Distance of 0th moment to its target value 1
#         W0th_abs = np.reshape(abs(W_Gau_0th_vari[:, :, 10000] - 1), Trunc_rn * hn)
#         # 1st moment
#         W1st = np.reshape(W_Gau_1st_vari[:, :, 10000], Trunc_rn * hn)

#         orderr = np.linspace(0, Trunc_rn * hn - 1, Trunc_rn * hn)


#         # The distance between 2 moment to target value(0 and 1)
#         Choice = W0th_abs + W1st

        # Chioce the 0th and 1st moment parameter that are the most close to the 
        # target value

        W_Gau_0th_fix = np.zeros(Q_length)
        W_Gau_1st_fix = np.zeros(Q_length)
        Trunc_r_fix = np.zeros(Q_length)
        Distance_r_fix_index = np.zeros(Q_length)
        h_fix = np.zeros(Q_length)

        for j in range(Q_length):

            W0th_abs = np.reshape(abs(W_Gau_0th_vari[:, :, j] - 1), Trunc_rn * hn)
            W1st = np.reshape(W_Gau_1st_vari[:, :, j], Trunc_rn * hn)
            Choice = W0th_abs + W1st

            MCT = np.zeros((3, 2))
            MCT_Weighted = np.zeros((3, 1))
            for i in range(3):
                MCT[i, 0] = min(Choice)
                MCT[i, 1] = Choice.argmin()
                Choice[int(MCT[i, 1])] = Choice[int(MCT[0, 1])] + 1

            for i in range(3):  
                MCT_Weighted[i, 0] = MCT[i, 0] * (MCT[i, 1] / 100)

            MCT_0 = min(MCT_Weighted[:, 0])
            MCT_Weighted_index = MCT_Weighted[:, 0].argmin()

            MCT_0_index = MCT[MCT_Weighted_index, 1]

            MCT_index_row = int(MCT_0_index // 10)
            MCT_index_column = int(MCT_0_index % 10)

            # Randomly pick a point and see its PDF for a slance check.
#             W_Gau_0th_fix[j] = W_Gau_0th_vari[MCT_index_row, MCT_index_column, 1000]
#             W_Gau_1st_fix[j] = W_Gau_1st_vari[MCT_index_row, MCT_index_column, 1000]
#             Trunc_r_fix[j] = Trunc_r_range[MCT_index_row]

            # Two key paremeters, will use in kernel derivateve
            Distance_r_fix_index[j] = MCT_index_row
            h_fix[j] = h_range[MCT_index_column]

        # Show how well the origin data out of by our smooth algorithm with choice
        # parameter.

        W_GauProve = np.zeros((Q_length, 1))

        @jit(nopython=True)
        def DistanceAllP(distance, PoinsIndex, VolVoeSubj, h, DataF):

            W_Gauij = 0
            N_Data = len(distance)
            aGau = 1 / (pow(math.pi, 1.5) * pow(h, 3))    
            for j in range(N_Data):

                q = distance[j] / h
                W_GauN = aGau * (2.7128 ** ( -1 * (q ** 2)))
                W_Gauij = W_Gauij + W_GauN * VolVoeSubj[PoinsIndex[j]] * \
                DataF[PoinsIndex[j]][0]

            return(W_Gauij)

        for i in range(Q_length) :
            r_index = int(Distance_r_fix_index[i])

            W_GauProve[i] = DistanceAllP(distance[r_index][i], \
                                         PoinsInd[r_index][i], \
                                         VolVoeSubj, \
                                        h_fix[i], DataF)

        Inter_Plot = np.linspace(0, 100, len(W_GauProve))
        Data_Plot = np.linspace(0, 100, len(DataF))

        # Determine the partial derivative along each dimension

        W_GauProvePD = np.zeros((Q_length, 1))
        Gauij_dev_x = np.zeros((Q_length, 1))
        Gauij_dev_y = np.zeros((Q_length, 1))
        Gauij_dev_z = np.zeros((Q_length, 1))
        Gx = np.zeros((Q_length, 1)) 

        @jit(nopython=True)
        def PD_fix(distance, PoinsIndex, VolVoeSubj, h, DataF, DataX, DataY, \
                                         DataZ, x_Inter, y_Inter, z_Inter):
            W_Gauij = 0
            Gauij_dev_x = 0
            Gauij_dev_y = 0
            Gauij_dev_z = 0

            N_Data = len(distance)
            aGau = 1 / (pow(math.pi, 1.5) * (h ** 3))    
            for j in range(N_Data):

                q = distance[j] / h
                W_GauN = aGau * (2.7128 ** ( -1 * (q ** 2)))
                W_Gauij = W_Gauij + W_GauN * VolVoeSubj[PoinsIndex[j]] * \
                DataF[PoinsIndex[j]][0]

                dx = (x_Inter - DataX[PoinsIndex[j]]) / distance[j]
                dy = (y_Inter - DataY[PoinsIndex[j]]) / distance[j]
                dz = (z_Inter - DataZ[PoinsIndex[j]]) / distance[j]

                Gau_dev_x = dx * aGau * \
                math.exp(-1 * q * q) * (-2 * distance[j] / (h * h))

                Gauij_dev_x = Gauij_dev_x + Gau_dev_x[0] * \
                VolVoeSubj[PoinsIndex[j]] * DataF[PoinsIndex[j]][0]  

                Gau_dev_y = dy * aGau * \
                math.exp(-1 * q * q) * (-2 * distance[j] / (h * h))

                Gauij_dev_y = Gauij_dev_y + Gau_dev_y[0] * \
                VolVoeSubj[PoinsIndex[j]] * DataF[PoinsIndex[j]][0] 

                Gau_dev_z = dz * aGau * \
                math.exp( -1 * q * q) * (-2 * distance[j] / (h * h))

                Gauij_dev_z = Gauij_dev_z + Gau_dev_z[0] * \
                VolVoeSubj[PoinsIndex[j]] * DataF[PoinsIndex[j]][0] 

            return(W_Gauij, Gauij_dev_x, Gauij_dev_y, Gauij_dev_z)


        for i in range(Q_length) :
            r_index = int(Distance_r_fix_index[i])

            W_GauProvePD[i], Gauij_dev_x[i], Gauij_dev_y[i], Gauij_dev_z[i]  = \
            PD_fix(distance[r_index][i], PoinsInd[r_index][i], \
                                         VolVoeSubj, h_fix[i], DataF, DataX, DataY, \
                                         DataZ, x_Inter[i], y_Inter[i], z_Inter[i])


        import copy
        lenDD = len(Gauij_dev_x)

        DD1 = copy.deepcopy(Gauij_dev_x)
        DD2 = copy.deepcopy(Gauij_dev_y)
        DD3 = copy.deepcopy(Gauij_dev_z)

        LastEigenvector = np.zeros((lenDD, 3))
        LastEigenvectorABS = np.zeros((lenDD, 3))
        for i in range(lenDD):
        # for i in range(1):
            pFpi = np.vstack((DD1[i], DD2[i], DD3[i]))
            #print(pFpi)#1*3
        #     WW = np.outer(pFpi, pFpi.transpose())
            WW = np.dot(pFpi, pFpi.transpose())
            #print(WW)
            Eigenvalues, Eigenvectors = np.linalg.eig(WW)
        #     print(Eigenvalues)
        #     print(Eigenvectors)
            EigneValue_MaxIndex = Eigenvalues.argmax()
        #     print('Max index is: ', EigneValue_MaxIndex)
            vesSwitch = Eigenvectors[:, EigneValue_MaxIndex]
        #     print(vesSwitch)

            LastEigenvectorABS[i, 0] = abs(vesSwitch[0])
            LastEigenvectorABS[i, 1] = abs(vesSwitch[1])
            LastEigenvectorABS[i, 2] = abs(vesSwitch[2])
        #     print(LastEigenvectorABS)

        EigenFrame = pd.DataFrame({'Ev_x':LastEigenvectorABS[:, 0], \
                                   'Ev_y':LastEigenvectorABS[:, 1], \
                                  'Ev_z':LastEigenvectorABS[:, 2]})
        EigenFrame.to_csv("Eigenvector.csv", index = False, sep = ',')

        PD_data = np.vstack((LastEigenvectorABS[:, 0].transpose(), \
                             LastEigenvectorABS[:, 1].transpose(), \
                           LastEigenvectorABS[:, 2].transpose()))

        import numpy as np
        from sklearn.cluster import KMeans

        class FuzzyKMeans3D:

            def __init__(self, n_clusters=8, m=2, max_iter=100, tol=1e-4):
                self.n_clusters = n_clusters
                self.m = m
                self.max_iter = max_iter
                self.tol = tol

            def fit(self, X):
                # Clusting center points
                kmeans = KMeans(n_clusters=self.n_clusters, max_iter=self.max_iter, tol=self.tol)
                kmeans.fit(X)
                centers = kmeans.cluster_centers_

                # Initialise belonging metrix
                n_samples = X.shape[0]
                U = np.random.rand(n_samples, self.n_clusters)
                U /= np.sum(U, axis=1)[:, None]

                # Iterate belonging metrix and center points
                for i in range(self.max_iter):
                    # Update Belongingbility
                    distances = np.linalg.norm(X[:, None, :] - centers[None, :, :], axis=2)
                    distances[distances == 0] = 1e-10  
                    U_new = 1 / distances ** (2 / (self.m - 1))
                    U_new /= np.sum(U_new, axis=1)[:, None]

                    # Check if converge
                    if np.allclose(U, U_new, rtol=self.tol):
                        break

                    U = U_new

                    # Update centers
                    centers = np.dot(U.T, X) / np.sum(U, axis=0)[:, None]

                # Return
                labels = np.argmax(U, axis=1)
                return centers, labels, U


        from mpl_toolkits.mplot3d import Axes3D
        import matplotlib.pyplot as plt

        PD_data = PD_data.transpose()

        fkm = FuzzyKMeans3D(n_clusters = ClusterRegion)
        centers, labels, U = fkm.fit(PD_data)


        RegionA_dev_x = copy.deepcopy(PD_data[labels == 0, 0])
        RegionA_dev_y = copy.deepcopy(PD_data[labels == 0, 1])
        RegionA_dev_z = copy.deepcopy(PD_data[labels == 0, 2])

        RegionB_dev_x = copy.deepcopy(PD_data[labels == 1, 0])
        RegionB_dev_y = copy.deepcopy(PD_data[labels == 1, 1])
        RegionB_dev_z = copy.deepcopy(PD_data[labels == 1, 2])

        EigenRegionA = pd.DataFrame({'Ev_x':RegionA_dev_x, \
                                   'Ev_y':RegionA_dev_y, \
                                  'Ev_z':RegionA_dev_z})
        EigenRegionA.to_csv("EigenRegionA.csv", index = False, sep = ',')

        EigenRegionB = pd.DataFrame({'Ev_x':RegionB_dev_x, \
                                   'Ev_y':RegionB_dev_y, \
                                  'Ev_z':RegionB_dev_z})
        EigenRegionB.to_csv("EigenRegionB.csv", index = False, sep = ',')

        RegionA_len = len(RegionA_dev_x)
        RegionB_len = len(RegionB_dev_x)

        Sum_RegionA = np.zeros((3, 3))
        Sum_RegionB = np.zeros((3, 3))

        for i in range(RegionA_len):

            pFpi_RegionA = np.vstack((RegionA_dev_x[i], RegionA_dev_y[i], \
                                      RegionA_dev_z[i]))
            WW_RegionA = np.dot(pFpi_RegionA, pFpi_RegionA.transpose())
            Sum_RegionA = Sum_RegionA + WW_RegionA

        Eigenvalues_RegionA, Eigenvectors_RegionA = np.linalg.eig(Sum_RegionA)
        EigneValue_MaxIndex_RegionA = Eigenvalues_RegionA.argmax()
        vesSwitch_RegionA = Eigenvectors_RegionA[:, EigneValue_MaxIndex_RegionA]
        Coord_RegionA = abs(vesSwitch_RegionA)

        for i in range(RegionB_len):

            pFpi_RegionB = np.vstack((RegionB_dev_x[i], RegionB_dev_y[i], \
                                      RegionB_dev_z[i]))
            WW_RegionB = np.dot(pFpi_RegionB, pFpi_RegionB.transpose())
            Sum_RegionB = Sum_RegionB + WW_RegionB

        Eigenvalues_RegionB, Eigenvectors_RegionB = np.linalg.eig(Sum_RegionB)
        EigneValue_MaxIndex_RegionB = Eigenvalues_RegionB.argmax()
        vesSwitch_RegionB = Eigenvectors_RegionB[:, EigneValue_MaxIndex_RegionB]
        Coord_RegionB = abs(vesSwitch_RegionB)

        print('Ra: ', Coord_RegionA, '\n', 'Rb: ', Coord_RegionB)

#         print(EigneValue_MaxIndex_RegionA)
#         print(Eigenvectors_RegionA)
#         print(EigneValue_MaxIndex_RegionB)
#         print(Eigenvectors_RegionB)
