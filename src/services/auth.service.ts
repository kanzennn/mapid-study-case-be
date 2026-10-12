import bcrypt from 'bcrypt';
import { userRepository } from '../repositories/user.repository';
import { AppError } from '../utils/AppError';
import { signToken } from '../utils/jwt';
import { sanitizeUser } from '../utils/sanitizeUser';
import { LoginInput } from '../validations/auth.validation';

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

    if (!user.is_active) {
      throw new AppError('Your account has been deactivated', 401);
    }

    const token = signToken({ userId: user.id, role: user.role });
    return { user: sanitizeUser(user), token };
  },
};
