function tests = TestSignalDetection
  tests = functiontests(localfunctions);
end

function testDPrimeZero(testCase)

  obj      = SignalDetection(15, 5, 15, 5);
  actual   = obj.d_prime();
  expected = 0;
  verifyEqual(testCase, actual, expected, 'AbsTol', 1e-6);
  
end

function testDPrimeNonzero(testCase)
  
  obj      = SignalDetection(15, 10, 15, 5);
  actual   = obj.d_prime();
  expected = -0.421142647060282;
  verifyEqual(testCase, actual, expected, 'AbsTol', 1e-6);
  
end

function testCriterionZero(testCase)

  obj = SignalDetection(5, 5, 5, 5);
  actual = obj.criterion();
  expected = 0;
  testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);
  
end

function testCriterionNonzero(testCase)

  obj = SignalDetection(15, 10, 15, 5);
  actual = obj.criterion();
  expected = -0.463918426665941;
  testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);
  
end

