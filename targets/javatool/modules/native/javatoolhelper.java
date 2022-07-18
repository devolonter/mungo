class JavaToolHelper {
    static int ParseInt(String s) {
        try {
            return Integer.parseInt(s);
        } catch (NumberFormatException e) {
            int len = s.length();
            if (len < 1) {
                return 0;
            }

            int sign = 1;
            int i = 0;

            while (s.charAt(i) == ' ') {
                i++;
            }

            if (s.charAt(i) == '+') {
                i++;
            } else if (s.charAt(i) == '-') {
                sign = -1;
                i++;
            }

            long n = 0;
            while (i < len) {
                if (s.charAt(i) < '0' || s.charAt(i) > '9') {
                    break;
                }

                int digit = s.charAt(i) - '0';
                n = n * 10 + digit;

                if (n > Integer.MAX_VALUE && sign == 1) {
                    break;
                }

                i++;
            }

            n *= sign;

            if (n > Integer.MAX_VALUE) {
                n = Integer.MAX_VALUE;
            }
            if (n < Integer.MIN_VALUE) {
                n = Integer.MIN_VALUE;
            }

            return (int) n;
        }
    }

    static float ParseFloat(String s) {
        try {
            return Float.parseFloat(s);
        } catch (NumberFormatException e) {
            // TODO: support of 'E'

            int len = s.length();
            if (len < 1) {
                return 0;
            }

            int sign = 1;
            int i = 0;

            while (s.charAt(i) == ' ') {
                i++;
            }

            if (s.charAt(i) == '+') {
                i++;
            } else if (s.charAt(i) == '-') {
                sign = -1;
                i++;
            }

            long n = 0;
            while (i < len) {
                if (s.charAt(i) < '0' || s.charAt(i) > '9') {
                    break;
                }

                int digit = s.charAt(i) - '0';
                n = n * 10 + digit;

                i++;
            }

            if (i < len && s.charAt(i) == '.') {
                long nv = 0;
                long nd = 1;
                i++;
                while (i < len) {
                    if (s.charAt(i) < '0' || s.charAt(i) > '9') {
                        break;
                    }

                    int digit = s.charAt(i) - '0';
                    nv = nv * 10 + digit;
                    nd = nd * 10;
                    i++;
                }

                return ((float) nv / (float) nd + n) * sign;
            }

            return (float) n * sign;
        }
    }
}
