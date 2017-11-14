%  Qinv.m
%
   function y=Qinv(x)
%  This program computes the inverse Q function or the value 
%  which is exceeded by a N(0,1) random variable with a 
%  probability of x.
%
%  Input Parameters:
%
%    x - Real column vector of right-tail probabilities
%        (in interval [0,1])
%
%  Output Parameters:
%
%    y - Real column vector of values of random variable
%
%  Verification Test Case:
%  
%  The input x=[0.5 0.1587 0.0228]'; should produce 
%  y=[0 0.9998 1.9991]'.
%
   y=sqrt(2)*erfinv(1-2*x);

