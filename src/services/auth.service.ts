import bcrypt from 'bcrypt';
import { userRepository } from '../repositories/user.repository';
import { AppError } from '../utils/AppError';
import { signToken } from '../utils/jwt';
import { LoginInput } from '../validations/auth.validation';

const sanitizeUser = (user: { id: string; name: string; email: string }) => ({
  id: user.id,
  name: user.name,
  email: user.email,
});

export const authService = {
  async login(input: LoginInput) {
    const user = await userRepository.findByEmail(input.email);
    if (!user) {
      throw new AppError('Invalid email or password', 401);
    }

    const isValidPassword = await bcrypt.compare(input.password, user.password);
    if (!isValidPassword) {
      throw new AppError('Invalid email or password', 401);
    }

    const token = signToken({ userId: user.id });
    return { user: sanitizeUser(user), token };
  },
};
