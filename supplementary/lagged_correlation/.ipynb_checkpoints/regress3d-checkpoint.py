import numpy as np
from scipy.stats import t as st

def regress3d(X,Y,*args):
    """ Assumes time is the first dimension:
    Inputs:
    X is a 1D array of length [t]
    Y is a 3D array with dimensions [t,x,y]
    Usage:
    expvar,coeffs,p,r = regress3d(X,Y) 
    Outputs:
    expvar is the explained variance: dimensions [x,y]
    coeffs contains the regression coefficients: dimensions [2,x,y]; [0,x,y] contains the intercept, [1,x,y] contains the slope
    p contains the p-value: dimensions [x,y]
    r contains the correlation: dimensions [x,y]"""
    s1=X.shape
    t1=np.array(Y.shape)

    try:
        s1[0] != t1[0]
    except:
        print('Arrays are not compatible - length(X) ~= length of 1st dimension of Y')
        raise
        
    if args:
        nf=args
    else:
        nf=s1[0]

    try:
        nf >= 1
    except:
        print('Invalid value supplied for nf: 1 < nf < length(y)')
        raise

    Xin=np.concatenate((np.ones(s1[0])[None,:],X[None,:]),axis=0)
    Y=np.reshape(Y,(t1[0],t1[1]*t1[2]),order='F')

    #regress: output size [2,t1*t2]
    coeffs=np.linalg.lstsq(Xin.T,Y,rcond=None)[0]

    #get predicted values
    Z=np.outer(coeffs[0,:],Xin[0,:]).T+np.outer(coeffs[1,:],Xin[1,:]).T

    #get sum squared errors
    errs = Y - Z
    SSE=np.sum(errs**2,axis=0)/(s1[0]-1)

    #get data variance
    SSY=np.var(Y,axis=0,ddof=1)

    #and % variance explained
    expvar=(1-(SSE/SSY))*100.0
    expvar=np.reshape(expvar,(t1[1],t1[2]),order='F')

    #reshape Z
    #Z=np.reshape(Z,t1,order='F') #don't return Z

    #=====calculate significance values=====
    #=standard error on slope
    #====get standard error on slope====

    #---standard deviation of Y
    SSyx = (1.0/(nf-2)) * np.sum(errs**2,axis=0)
    SSyy = np.sum((Y-np.tile(np.mean(Y,axis=0)[None,:],(t1[0],1)))**2,axis=0)
    SSxx=np.sum((X-np.mean(X))**2)

    serr = np.sqrt( SSyx/SSxx )

    #=== t-statistic ===
    # t = slope of regression / standard error of slope
    t = coeffs[1,:] / serr
    #convert to p
    p = 2*(1-st.cdf(abs(t),nf-2))

    #Done with coeffs array, can reshape to output size now
    coeffs=np.reshape(coeffs,(2,t1[1],t1[2]),order='F')
    p=np.reshape(p,(t1[1],t1[2]),order='F')

    r=0.1*np.sqrt(expvar)
    mult=np.squeeze(coeffs[1,:,:].copy())
    mult[mult > 0]=1
    mult[mult < 0]=-1
    r=r*mult

    return expvar,coeffs,p,r