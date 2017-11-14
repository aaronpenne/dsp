%  Q.m
%
   function y=Q(x)
%  This program computes the right-tail probability 
%  (complementary cumulative distribution function) for 
%  a N(0,1) random variable.
%
%  Input Parameters:
%
%    x - Real column vector of x values
%
%  Output Parameters:
%
%    y - Real column vector of right-tail probabilities
%
%  Verification Test Case:
%
%  The input x=[0 1 2]'; should produce y=[0.5 0.1587 0.0228]'.
%
  y=0.5*erfc(x/sqrt(2));

